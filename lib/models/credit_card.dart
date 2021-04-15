import 'package:credit_card_type_detector/credit_card_type_detector.dart';
import 'package:flutter/cupertino.dart';

class CreditCardModel extends ChangeNotifier {

  String number;
  String holder;
  String expirationDate;
  String securityCode;
  String brand;
  int parcelament = 1;

  //List<int> parcels = [1,2,3,4];

  void setHolder(String name) => holder = name;
  void setExpirationDate(String date) => expirationDate = date;
  void setCVV(String cvv) => securityCode = cvv;

  void setParcelament(int newValue) => parcelament = newValue;

  void setNumber(String number){
    this.number = number;
    brand = detectCCType(number.replaceAll(' ', '')).toString().toUpperCase().split(".").last;
  }

  Map<String,dynamic> toJson(){
    return {
      'cardNumber': number.replaceAll(' ', ''),
      'holder': holder,
      'expirationDate': expirationDate,
      'securityCode': securityCode,
      'brand': brand,
    };
  }

}