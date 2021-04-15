import 'package:alphabet_list_scroll_view/alphabet_list_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/common/custum_drawer/custom_drawer.dart';
import 'package:loja_virtual/models/admin_orders_manager.dart';
import 'package:loja_virtual/models/admin_users_manager.dart';
import 'package:loja_virtual/models/page_manager.dart';
import 'package:provider/provider.dart';

class AdminUserScrenn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
        appBar: AppBar(
          title: Text('Usuários'),
          centerTitle: true,
        ),
        body: Consumer<AdminUserManager>(
          builder: (_, adminUsersManager, __) {
            return AlphabetListScrollView(
              indexedHeight: (index) => 80,
              strList: adminUsersManager.names,
              showPreview: true,
              normalTextStyle: TextStyle(color: Colors.white),
              highlightTextStyle: TextStyle(color: Colors.amber[600], fontSize: 20),
              itemBuilder: (_, index) {
                return ListTile(
                  title: Text(
                    adminUsersManager.users[index].name,
                    style: TextStyle(color: Colors.amber[600]),
                  ),
                  subtitle: Text(
                    adminUsersManager.users[index].email,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w400),
                  ),
                  onTap: () {
                    context
                        .read<AdminOrdersManager>()
                        .setUserFilter(adminUsersManager.users[index]);
                    context.read<PageManager>().setPage(5);
                  },
                );
              },
            );
          },
        ));
  }
}
