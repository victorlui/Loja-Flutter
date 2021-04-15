import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_virtual/models/order.dart';
import 'package:loja_virtual/models/user.dart';

class AdminOrdersManager extends ChangeNotifier {
  final Firestore firestore = Firestore.instance;
  StreamSubscription _subscription;

  final List<Order> _orders = [];
  User userFilter;
  List<Status> statusFilter = [Status.preparing];

  void updateAdmin(bool adminEnabled) {
    _orders.clear();
    _subscription?.cancel();
    if (adminEnabled) {
      _listToOrders();
    }
  }

  List<Order> get filterOrders {
    List<Order> output = _orders.reversed.toList();

    if (userFilter != null) {
      output =
          output.where((element) => element.userId == userFilter.id).toList();
    }

    return output = output.where((o) => statusFilter.contains(o.status)).toList();

    
  }

  void _listToOrders() {
    _subscription = firestore.collection('orders').snapshots().listen((event) {
      for (final change in event.documentChanges) {
        switch (change.type) {
          case DocumentChangeType.added:
            _orders.add(Order.fromDocument(change.document));
            break;

          case DocumentChangeType.modified:
            final modOrder = _orders.firstWhere(
                (element) => element.orderId == change.document.documentID);
            modOrder.updateFromDocument(change.document);
            break;

          case DocumentChangeType.removed:
            break;
        }
      }
      notifyListeners();
    });
  }

  //filtrar user
  void setUserFilter(User user) {
    userFilter = user;
    notifyListeners();
  }

  void setStatusFilter(Status status, bool enabled){
    if(enabled){
      statusFilter.add(status);
    }else{
      statusFilter.remove(status);
    }

    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    _subscription?.cancel();
  }
}
