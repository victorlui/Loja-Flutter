import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_virtual/models/cart_manager.dart';
import 'package:loja_virtual/models/credit_card.dart';
import 'package:loja_virtual/models/order.dart';
import 'package:loja_virtual/models/products.dart';
import 'package:loja_virtual/services/cielo_api.dart';

class CheckoutManager extends ChangeNotifier {
  final Firestore firestore = Firestore.instance;
  final CieloApi cieloApi = CieloApi();

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  CartManager cartManager;

  // ignore: use_setters_to_change_properties
  void updateCart(CartManager cartManager) {
    this.cartManager = cartManager;
  }

  Future<void> checkout(
      {CreditCardModel creditCard,
      onStockFail,
      Function onSuccess,
      Function onPayFail}) async {
    loading = true;

    final orderId = await _getOrderId();

    //verifica o pagamento e gera um id
     String payId;
    try {
       payId = await cieloApi.authorize(creditCard,
          cartManager.totalPrice, orderId.toString(), cartManager.user);

      debugPrint(payId);
    } catch (e) {
      debugPrint(e);
      onPayFail(e);
      loading = false;
      return;
    }

   try {
      await _decrementStock();
    } catch (e) {
      cieloApi.cancel(payId);
      onStockFail(e);
      loading = false;
      return;
    }

    //captura do pagamento
    try{
      await cieloApi.caputure(payId);
    }catch(e){
      onPayFail(e);
      loading = false;
      return;
    }


    //enviar pedido no firebase
    final order = Order.fromCartManager(cartManager);
    order.orderId = orderId.toString();
    order.payId = payId;

    await order.save();

    cartManager.clear();

    onSuccess(order);
    loading = false;
  }

//criando um numero do pedido
  Future<int> _getOrderId() async {
    final ref = firestore.document('aux/ordercounter');

    try {
      //transação
      final result = await firestore.runTransaction((tx) async {
        final doc = await tx.get(ref);
        final orderId = doc.data['current'] as int;

        await tx.update(ref, {'current': orderId + 1});

        return {'orderId': orderId};
      });
      return result['orderId'] as int;
    } catch (e) {
      debugPrint(e);
      return Future.error('Falha ao gerar número do Pedido');
    }
  }

  //decrementar o stock
  Future<void> _decrementStock() {
    // 3- salvar os estoques no firebase

    // 1- Ler todos os estoques
    // 2- decremento localmente os estoques
    return firestore.runTransaction((tx) async {
      final List<Products> productsToUpdate = [];
      final List<Products> productWithoutStock = [];

      for (final cartProduct in cartManager.items) {
        Products product;

        if (productsToUpdate.any((p) => p.id == cartProduct.productId)) {
          product = productsToUpdate
              .firstWhere((element) => element.id == cartProduct.productId);
        } else {
          final doc = await tx
              .get(firestore.document('products/${cartProduct.productId}'));

          product = Products.fromDocument(doc);
        }

        cartProduct.product = product;

        final size = product.findSize(cartProduct.size);

        if (size.stock - cartProduct.quantity < 0) {
          productWithoutStock.add(product);
        } else {
          size.stock -= cartProduct.quantity;
          productsToUpdate.add(product);
        }
      }

      if (productWithoutStock.isNotEmpty) {
        return Future.error(
            '${productWithoutStock.length} produto(s) sem estoque');
      }

      for (final product in productsToUpdate) {
        tx.update(firestore.document('products/${product.id}'),
            {'sizes': product.exportSizeList()});
      }
    });
  }
}
