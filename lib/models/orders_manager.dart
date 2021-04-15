import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:loja_virtual/models/order.dart';
import 'package:loja_virtual/models/user.dart';

class OrdersManager extends ChangeNotifier {
  final Firestore firestore = Firestore.instance;
  StreamSubscription _subscription;

  User user;

  List<Order> orders = [];

  void updateUser(User user) {
    this.user = user;
    orders.clear();
    _subscription?.cancel();
    if (user != null) {
      _listToOrders();
    }
  }

  void _listToOrders() {
    _subscription = firestore
        .collection('orders')
        .where('user', isEqualTo: user.id)
        .snapshots()
        .listen((event) {
      orders.clear();
      for (final doc in event.documents) {
        orders.add(Order.fromDocument(doc));
      }
      notifyListeners();
    });
  }

  @override
  void dispose() {
    
    super.dispose();
    _subscription?.cancel();
  }
}
