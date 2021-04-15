import 'package:flutter/material.dart';
import 'package:loja_virtual/common/custum_drawer/custom_drawer.dart';
import 'package:loja_virtual/models/products_manager.dart';
import 'package:loja_virtual/models/user_manager.dart';
import 'package:loja_virtual/screens/products/components/product_list_tile.dart';
import 'package:loja_virtual/screens/products/components/search_dialog.dart';
import 'package:provider/provider.dart';

class ProductsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: Consumer<ProductsManager>(
          builder: (_, productsManager, __) {
            if (productsManager.search.isEmpty) {
              return Text('Produtos');
            } else {
              return LayoutBuilder(
                builder: (_, constraints) {
                  return GestureDetector(
                      child: Container(
                        child: Text(productsManager.search),
                        width: constraints.biggest.width,
                      ),
                      onTap: () async {
                        final search = await showDialog<String>(
                            context: context,
                            builder: (_) =>
                                SearchDialog(productsManager.search));

                        if (search != null) {
                          productsManager.search = search;
                        }
                      });
                },
              );
            }
          },
        ),
        centerTitle: true,
        actions: [
          // ignore: missing_return
          Consumer<ProductsManager>(
            builder: (_, productsManager, __) {
              if (productsManager.search.isEmpty) {
                return IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () async {
                    final search = await showDialog<String>(
                        context: context,
                        builder: (_) => SearchDialog(productsManager.search));

                    if (search != null) {
                      productsManager.search = search;
                    }
                  },
                );
              } else {
                return IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () async {
                    productsManager.search = '';
                  },
                );
              }
            },
          ),
           Consumer<UserManager>(
              builder: (_, userManager, __) {
                if (userManager.adminEnabled) {
                  return IconButton(icon: Icon(Icons.add), onPressed: () {
                   Navigator.of(context).pushNamed('/edit-product');
                  });
                } else {
                  return Container();
                }
              },
            )
          
        ],
      ),
      body: Consumer<ProductsManager>(builder: (_, productManager, __) {
        final filteredProducts = productManager.filteredProducts;
        return ListView.builder(
          itemCount: filteredProducts.length,
          itemBuilder: (_, index) {
            return ProductListTile(
              filteredProducts[index],
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        foregroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          Navigator.of(context).pushNamed('/cart');
        },
        child: Icon(Icons.shopping_cart),
      ),
    );
  }
}
