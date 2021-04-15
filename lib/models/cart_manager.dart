import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:loja_virtual/models/address.dart';
import 'package:loja_virtual/models/cart_product.dart';
import 'package:loja_virtual/models/products.dart';
import 'package:loja_virtual/models/user.dart';
import 'package:loja_virtual/models/user_manager.dart';
import 'package:loja_virtual/services/cep_service.dart';

//lista do carrrinho de compras
class CartManager extends ChangeNotifier {
  List<CartProduct> items = [];

  final Firestore firestore = Firestore.instance;

  User user;
  Address address;

  num productsPrice = 0.0;
  num deliveryPrice;

  num get totalPrice => productsPrice + (deliveryPrice ?? 0);

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool value){
    _loading = value;
    notifyListeners();
  }

  void updateUser(UserManager userManager) {
    user = userManager.user;
    productsPrice = 0.0;
    items.clear();
    removedAddress();

    if (user != null) {
      _loadCartItems();
      _loadUserAddress();
    }
  }

  //carregar o endereço do usuario
  Future<void> _loadUserAddress() async {
    if(user.address != null && await calculateDelivery(user.address.lat, user.address.long)){
      address = user.address;
      notifyListeners();
    }
  }

  //carrega o carrinho do usuario
  Future<void> _loadCartItems() async {
    final QuerySnapshot cartSnap = await user.cartReference.getDocuments();

    //array receber o carrinho
    items = cartSnap.documents
        .map((d) => CartProduct.fromDocument(d)..addListener(_onItemUpdate))
        .toList();
  }

  //adicionar ao carrinho
  void addToCart(Products product) {
    try {
      final e = items.firstWhere((p) => p.stackable(product));
      e.increment();
    } catch (e) {
      final cartProduct = CartProduct.fromProduct(product);
      cartProduct.addListener(_onItemUpdate);
      items.add(cartProduct);
      user.cartReference
          .add(cartProduct.toCartItemMap())
          .then((doc) => cartProduct.id = doc.documentID);
      _onItemUpdate();
    }
  }

//atualizar o item do carrinho
  void _onItemUpdate() {
    productsPrice = 0.0;

    for (int i = 0; i < items.length; i++) {
      final cartProduct = items[i];

      if (cartProduct.quantity == 0) {
        removeOfItemCart(cartProduct);
        i--;
        continue;
      }
      productsPrice += cartProduct.totalPrice;
      __updateCartProduct(cartProduct);
    }

    notifyListeners();
  }

//atualiza a tela do carrinho
  void __updateCartProduct(CartProduct cartProduct) {
    if (cartProduct.id != null)
      user.cartReference
          .document(cartProduct.id)
          .updateData(cartProduct.toCartItemMap());
  }

  //remover do carrinho
  void removeOfItemCart(CartProduct cartProduct) {
    //remover da lista local
    items.removeWhere((p) => p.id == cartProduct.id);
    //remover do firebase
    user.cartReference.document(cartProduct.id).delete();
    cartProduct.removeListener(_onItemUpdate);
    notifyListeners();
  }

//retorna se verdeiro ou falso
  bool get isCartValid {
    for (final cartProduct in items) {
      if (!cartProduct.hasStock) return false;
    }
    return true;
  }

  //desabilita o botao enquanto não calcular o frete
  bool get isAddressValid => address != null && deliveryPrice != null;

  //busca cep
  Future<void> getAddress(String cep) async {
     loading = true;
    final cepService = CepAbertoService();

   
   
    try{
      final cepAbertoaddress = await cepService.getAddressFromCep(cep);
      //List<Location> locations = await locationFromAddress("$logradouro, $cidade");

      print(cepAbertoaddress);

     if(cepAbertoaddress != null){
       address = Address(
         street: cepAbertoaddress.logradouro,
          district: cepAbertoaddress.bairro,
          zipCode: cepAbertoaddress.cep,
          city: cepAbertoaddress.cidade.nome,
          state: cepAbertoaddress.estado.sigla,
          lat: cepAbertoaddress.latitude,
          long: cepAbertoaddress.longitude
       );
       
     }
      loading = false;
    }catch(e){
      //print(e);
        loading = false;
      return Future.error('CEP Inválido');
    }

  
  }

  Future<void> setAddress(Address address)async {
    loading = true;
    this.address = address;

    if( await calculateDelivery(address.lat, address.long)){
      user.setAddress(address);
      loading = false;
    }else{
      loading = false;
      return Future.error('Endereço fora do raio de entrega');
    }
  }

  //calcular frete
  Future<bool> calculateDelivery(double lat,double long) async {
    final DocumentSnapshot doc = await firestore.document('aux/delivery').get();

    
    final latStore = doc.data['lat'] as double;
    final longStore = doc.data['long'] as double;

    final base = doc.data['base'] as num;
    final km = doc.data['km'] as num;
    final maxkm = doc.data['maxkm'] as num;

    double dis = await Geolocator().distanceBetween(latStore,longStore,lat,long);

    dis /= 10000;

    if(dis > maxkm){
      return false;
    }

    deliveryPrice = base + dis + km;

    return true;

  }

  //limpar o carrinho
  void clear(){
    for(final cartProduct in items){
      user.cartReference.document(cartProduct.id).delete();
    }

    items.clear();
    notifyListeners();
  }

//remove cep
  void removedAddress(){
    address = null;
    deliveryPrice = null;
    notifyListeners();
  }
}
