import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_virtual/models/store.dart';

class StoresManager extends ChangeNotifier {
  List<Store> stores = [];
  Timer _timer;

  //construtor
  StoresManager() {
    _loadStore();
    _startTimer();
  }

  final Firestore firestore = Firestore.instance;

  Future<void> _loadStore() async {
    final snapshot = await firestore.collection('stores').getDocuments();

    stores = snapshot.documents.map((e) => Store.fromDocument(e)).toList();

    notifyListeners();
  }

  //verificar a cada minuto
  void _startTimer() {
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      _checkOpening();
    });
  }

  void _checkOpening() {
    for (final store in stores) store.updateStatus();
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }
}
