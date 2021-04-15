import 'package:flutter/material.dart';
import 'package:loja_virtual/common/custum_drawer/custom_drawer_header.dart';
import 'package:loja_virtual/common/custum_drawer/drawer_tile.dart';
import 'package:loja_virtual/models/user_manager.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomDrawer extends StatelessWidget {

  abrirWhatsApp() async {
  var whatsappUrl = "whatsapp://send?phone=+5517992036574&text=Olá,tudo bem ?";

  if (await canLaunch(whatsappUrl)) {
    await launch(whatsappUrl);
  } else {
    throw 'Could not launch $whatsappUrl';
  }
}

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Drawer(
          child: Stack(
        children: [
          Container(
            color: Colors.black,
          ),
          ListView(
            children: [
              CustomDrawerHeader(),
              const Divider(
                color: Colors.white60,
              ),
              DrawerTile(
                iconData: Icons.home,
                title: 'Home',
                page: 0,
              ),
              DrawerTile(
                iconData: Icons.list,
                title: 'Produtos',
                page: 1,
              ),
              DrawerTile(
                iconData: Icons.playlist_add_check,
                title: 'Meus pedidos',
                page: 2,
              ),
              DrawerTile(
                iconData: Icons.location_on,
                title: 'Loja',
                page: 3,
              ),
              Consumer<UserManager>(
                builder: (_, userManager, __) {
                  if (userManager.adminEnabled) {
                    return Column(
                      children: [
                        Divider(),
                        DrawerTile(
                          iconData: Icons.settings,
                          title: 'Usuários',
                          page: 4,
                        ),
                        DrawerTile(
                          iconData: Icons.settings,
                          title: 'Pedidos',
                          page: 5,
                        ),
                      ],
                    );
                  } else {
                    return Container();
                  }
                },
              ),
              InkWell(
                onTap: abrirWhatsApp,
                child: SizedBox(
                  height: 60,
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 32),
                        child: Icon(
                          Icons.chat,
                          size: 32,
                          color: Colors.white70,
                        ),
                      ),
                      Text('Suporte',
                          style:
                              TextStyle(fontSize: 16, color: Colors.white70)),
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      )),
    );
  }
}
