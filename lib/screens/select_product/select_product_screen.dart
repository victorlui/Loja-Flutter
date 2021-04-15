import 'package:flutter/material.dart';
import 'package:loja_virtual/models/products_manager.dart';
import 'package:provider/provider.dart';

class SelectProductScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Vincular Produto'),
          centerTitle: true,
        ),
        body: Consumer<ProductsManager>(builder: (_, productManager, __) {
          return ListView.builder(
              itemCount: productManager.allProducts.length,
              itemBuilder: (_, index) {
                final product = productManager.allProducts[index];
                return ListTile(
                  title: Text(product.name),
                  leading: Image.network(product.images.first),
                  subtitle: Text('R\$ ${product.basePrice.toStringAsFixed(2)}'),
                  onTap: (){
                    Navigator.of(context).pop(product);
                  },
                );
              });
        }));
  }
}
