import 'package:flutter/material.dart';
import 'package:loja_virtual/common/custum_drawer/custom_drawer.dart';
import 'package:loja_virtual/models/stores_manager.dart';
import 'package:loja_virtual/screens/stores/compoents/stores_card.dart';
import 'package:provider/provider.dart';

class StoreScreen extends StatelessWidget {
  const StoreScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Lojas'),
      ),
      body: Consumer<StoresManager>(builder: (_, storeManager, __) {
        if (storeManager.stores.isEmpty) {
          return LinearProgressIndicator(
            valueColor: AlwaysStoppedAnimation(Colors.white),
            backgroundColor: Colors.transparent,
          );
        }

        return ListView.builder(
            itemCount: storeManager.stores.length,
            itemBuilder: (_, index) {
              return StoreCard(storeManager.stores[index]);
            });
      }),
    );
  }
}
