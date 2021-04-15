import 'package:flutter/material.dart';
import 'package:loja_virtual/models/products.dart';

class ProductListTile extends StatelessWidget {
  const ProductListTile(this.product);

  final Products product;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed('/product', arguments: product);
        },
        child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            child: Container(
              height: 100,
              padding: EdgeInsets.all(8),
              child: Row(
                children: [
                  AspectRatio(
                    aspectRatio: 1,
                    child: Image.network(product.images.first),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          product.name,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w800),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 4),
                          child: Text(
                            'A partir de',
                            style: TextStyle(
                                color: Colors.grey[400], fontSize: 12),
                          ),
                        ),
                        Text(
                          'R\$ ${product.basePrice.toStringAsFixed(2)}',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: Theme.of(context).primaryColor),
                        ),
                        if (!product.hasStock)
                          const Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text('Sem estoque',
                                style:
                                    TextStyle(color: Colors.red, fontSize: 10)),
                          )
                      ],
                    ),
                  )
                ],
              ),
            )));
  }
}
