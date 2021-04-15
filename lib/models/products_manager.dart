import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_virtual/models/products.dart';

class ProductsManager extends ChangeNotifier {
  ProductsManager() {
    _loadAllProducts();
  }

  final Firestore firestore = Firestore.instance;

  List<Products> allProducts = [];

  String _search = '';
  String get search => _search;

  set search(String value) {
    _search = value;
    notifyListeners();
  }

  //listar todos os produtos
  Future<void> _loadAllProducts() async {
    //pega todos os products
    final QuerySnapshot snapProducts = await firestore
        .collection('products')
        .where('deleted', isEqualTo: false)
        .getDocuments();

    //cria uma lista de produtos
    allProducts =
        snapProducts.documents.map((d) => Products.fromDocument(d)).toList();

    notifyListeners();
  }

  //pesquisar
  List<Products> get filteredProducts {
    final List<Products> filteredProducts = [];

    if (search.isEmpty) {
      filteredProducts.addAll(allProducts);
    } else {
      filteredProducts.addAll(
          allProducts.where((p) => p.name.toLowerCase().contains(search)));
    }
    return filteredProducts;
  }

  //buscar p id do produto
  Products findProductById(String id) {
    try {
      return allProducts.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  void update(Products product) {
    allProducts.removeWhere((p) => p.id == product.id);
    allProducts.add(product);
    notifyListeners();
  }

  void deleteProduct(Products product) {
    product.delete();
    allProducts.removeWhere((p) => p.id == product.id);
    notifyListeners();
  }
}
