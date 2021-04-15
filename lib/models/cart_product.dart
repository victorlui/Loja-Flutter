import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_virtual/models/item_size.dart';
import 'package:loja_virtual/models/products.dart';

//especifica um item no carrinho
class CartProduct extends ChangeNotifier {
  final Firestore firestore = Firestore.instance;

  //construtor
  CartProduct.fromProduct(this._product) {
    productId = product.id;
    quantity = 1;
    size = product.selectedSize.name;
  }

  CartProduct.fromDocument(DocumentSnapshot document) {
    id = document.documentID;
    productId = document.data['pid'] as String;
    quantity = document.data['quantity'] as int;
    size = document.data['size'] as String;

    firestore.document('products/$productId').get().then((doc) {
      product = Products.fromDocument(doc);
     
    });
  }

  CartProduct.fromMap(Map<String,dynamic> map){
    productId = map['pid'] as String;
    quantity = map['quantity'] as int;
    size = map['size'] as String;
    fixedPrice = map['fixedPrice'] as num;

     firestore.document('products/$productId').get().then((doc) {
      product = Products.fromDocument(doc);
     
    });
  }

  String id;
  String productId;
  int quantity;
  String size;
  num fixedPrice;

  Products _product;
  Products get product => _product;
  set product(Products value){
    _product = value;
    notifyListeners();
  }

//pega o tamanho e retorna o itemsize  se nao retorna null
  ItemSize get itemSize {
    if (product == null) return null;
    return product.findSize(size);
  }

//pega o preço do tamanho selecionado que retornou no ItemSize
  num get unitPrice {
    if (product == null) return 0;
    return itemSize?.price ?? 0;
  }

  num get totalPrice => unitPrice * quantity;

  //salvar os dados do carrinho
  Map<String, dynamic> toCartItemMap() {
    return {
      'pid': productId,
      'quantity': quantity,
      'size': size,
    };
  }

   //salvar os dados do pedido
  Map<String, dynamic> toOrderItemMap() {
    return {
      'pid': productId,
      'quantity': quantity,
      'size': size,
      'fixedPrice': fixedPrice ?? unitPrice
    };
  }

  bool stackable(Products product) {
    return product.id == productId && product.selectedSize.name == size;
  }

  void increment() {
    quantity++;
    notifyListeners();
  }

  void decrement() {
    quantity--;
    notifyListeners();
  }

  bool get hasStock {
    if(product != null && product.deleted) return false;
    final size = itemSize;
    if (size == null) return false;
    return size.stock >= quantity;
  }
}
