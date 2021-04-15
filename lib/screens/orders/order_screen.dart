import 'package:flutter/material.dart';
import 'package:loja_virtual/common/custum_drawer/custom_drawer.dart';
import 'package:loja_virtual/common/empty_card.dart';
import 'package:loja_virtual/common/login_card.dart';
import 'package:loja_virtual/models/orders_manager.dart';
import 'package:loja_virtual/screens/orders/components/order_tile.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: const Text('Meus Pedidos'),
        centerTitle: true,
      ),
      body: Consumer<OrdersManager>(
        builder: (_, ordersManager, __) {
          if(ordersManager.user == null){
            return LoginCard();
          }

          if(ordersManager.orders.isEmpty){
            return EmptyCard(title: 'Nenhuma compra encontrada',icon: Icons.border_clear,);
          }

          return ListView.builder(
            itemCount: ordersManager.orders.length,
            itemBuilder: (_,index){
              return OrderTile(ordersManager.orders.reversed.toList()[index]);
            },
          );
        },
      ),
    );
  }
}
