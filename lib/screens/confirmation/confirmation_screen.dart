import 'package:flutter/material.dart';
import 'package:loja_virtual/models/order.dart';
import 'package:loja_virtual/models/page_manager.dart';
import 'package:loja_virtual/screens/orders/components/order_product_tile.dart';
import 'package:provider/provider.dart';

class ConfirmationScreen extends StatelessWidget {
  ConfirmationScreen(this.order);

  final Order order;

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pedido confirmado'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.navigate_before_outlined,
              size: 30, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(16),
          child: ListView(
            shrinkWrap: true,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.formattedId,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: primaryColor,
                      ),
                    ),
                    Text(
                      'R\$ ${order.price.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    )
                  ],
                ),
              ),
              Column(
                children: order.items.map((e) {
                  return OrderProductTile(e);
                }).toList(),
              ),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/');
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        color: Colors.black,
                        border: Border.all(
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(28)),
                    width: double.infinity,
                    child: Column(
                      children: [
                        Text(
                          'Voltar para o inicio',
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
