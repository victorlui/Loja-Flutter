import 'dart:collection';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:loja_virtual/models/credit_card.dart';
import 'package:loja_virtual/models/user.dart';

class CieloApi {
  final functions = CloudFunctions.instance;

  Future<String> authorize(
      CreditCardModel creditCard, num price, String orderId, User user) async {
        print(creditCard);
    try {
      final Map<String, dynamic> dataSale = {
        'merchantOrderId': orderId,
        'amount': (price * 100).toInt(),
        'softDescriptor:': 'CB Store',
        'installments': creditCard.parcelament,
        'creditCard': creditCard.toJson(),
        'cpf': user.cpf,
        'paymentType': 'CreditCard'
      };

      print(dataSale);

      final HttpsCallable callable =
          functions.getHttpsCallable(functionName: 'authorizeCreditCard');

      callable.timeout = const Duration(seconds: 60);

      final response = await callable.call(dataSale);

      //converter json para dart
      final data = Map<String, dynamic>.from(response.data as LinkedHashMap);

      if (data['success'] as bool) {
        return data['paymentId'] as String;
      } else {
        return Future.error(data['error']['message']);
      }
    } catch (e) {
      print(e);
      return Future.error('Falha ao processar a transação tente novamente');
    }
  }

  Future<void> caputure(String payId) async {
    final Map<String, dynamic> captureData = {'payId': payId};

    final HttpsCallable callable =
        functions.getHttpsCallable(functionName: 'captureCreditCard');
    callable.timeout = const Duration(seconds: 60);
    final response = await callable.call(captureData);
    print(response.data);
    //converter json para dart
    final data = Map<String, dynamic>.from(response.data as LinkedHashMap);
    if (data['success'] as bool) {
      return;
    } else {
      return Future.error(data['error']['message']);
    }
  }

  Future<void> cancel(String payId) async {
    final Map<String, dynamic> cancelData = {'payId': payId};

    final HttpsCallable callable =
        functions.getHttpsCallable(functionName: 'cancelCreditCard');
    callable.timeout = const Duration(seconds: 60);
    final response = await callable.call(cancelData);
    print(response.data);
    //converter json para dart
    final data = Map<String, dynamic>.from(response.data as LinkedHashMap);
    if (data['success'] as bool) {
      return;
    } else {
      return Future.error(data['error']['message']);
    }
  }
}
