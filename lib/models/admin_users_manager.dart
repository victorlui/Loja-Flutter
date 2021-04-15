import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/cupertino.dart';
import 'package:loja_virtual/models/user.dart';
import 'package:loja_virtual/models/user_manager.dart';

class AdminUserManager extends ChangeNotifier {

  final Firestore firestore = Firestore.instance;

  StreamSubscription _subscription;

  List<User> users = [];

  void updateUser(UserManager userManager){
    _subscription?.cancel();
    if(userManager.adminEnabled){
      _listenToUsers();
    }else{
      users.clear();
      notifyListeners();
    }
  }

  Future<void> _listenToUsers() async {
    _subscription =  firestore.collection('users').snapshots().listen((value) {
       users = value.documents.map((e) => User.fromDocument(e)).toList();
       users.sort((a,b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
        notifyListeners();

    });

   
  }

  List<String> get names => users.map((e) => e.name).toList();

  @override
  void dispose() {
    super.dispose();
    _subscription?.cancel();
  }
}