import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loja_virtual/models/page_manager.dart';
import 'package:loja_virtual/models/user_manager.dart';
import 'package:loja_virtual/screens/admin_orders/admin_order_screen.dart';
import 'package:loja_virtual/screens/admin_users/admin_users_screen.dart';
import 'package:loja_virtual/screens/home/home_screen.dart';
import 'package:loja_virtual/screens/orders/order_screen.dart';
import 'package:loja_virtual/screens/products/products_screen.dart';
import 'package:loja_virtual/screens/stores/stores_screen.dart';
import 'package:provider/provider.dart';
import 'package:another_flushbar/flushbar.dart';

class BaseScreen extends StatefulWidget {
  @override
  _BaseScreenState createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  final PageController pageController = PageController();

  @override
  void initState() {
    super.initState();
    //travar a orientação na tela
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp
    ]);

    configFCM();
  }

  void configFCM(){
    final fcm = FirebaseMessaging();

    if(Platform.isIOS){ 
      fcm.requestNotificationPermissions(
        const IosNotificationSettings(provisional: true)
      );
    }

    fcm.configure(
      onLaunch: (Map<String,dynamic> message) async{
        print('onLanc $message');
      },
      onResume: (Map<String,dynamic> message) async{
        print('onResume $message');
      },
      onMessage: (Map<String,dynamic> message) async{
        showNotification(
          message['notification']['title'] as String,
          message['notification']['body'] as String
        );
      },
    );
  }

  void showNotification(String title, String message) async {
    await Flushbar(
      title: title,
      message: message,
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.GROUNDED,
      isDismissible: true,
      backgroundColor: Theme.of(context).primaryColor,
      duration: const Duration(seconds: 5),
      icon: Icon(Icons.shopping_cart,color: Colors.white,),
    ).show(context);
  }


  @override
  Widget build(BuildContext context) {
    return Provider(
        create: (_) => PageManager(pageController),
        child: Consumer<UserManager>(
          builder: (_, userManager, __) {
            return PageView(
              controller: pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                HomeScreen(),
                ProductsScreen(),
                OrdersScreen(),
                StoreScreen(),
                if (userManager.adminEnabled) ...[
                  AdminUserScrenn(),
                  AdminOrderScreen()
                ]
              ],
            );
          },
        ));
  }
}
