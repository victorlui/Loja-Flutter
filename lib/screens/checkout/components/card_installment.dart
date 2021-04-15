import 'package:flutter/material.dart';
import 'package:loja_virtual/models/credit_card.dart';
import 'package:provider/provider.dart';

class CardInstallment extends StatefulWidget {

  CardInstallment(this.creditCard);

  final CreditCardModel creditCard;

  @override
  _CardInstallmentState createState() => _CardInstallmentState();
}

class _CardInstallmentState extends State<CardInstallment> {

   int selected = 1;

  @override
  Widget build(BuildContext context) {
    return  Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Parcelar em ',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                Container(
                  width: double.infinity,
                  child: DropdownButton<int>(
                    value: selected,
                    icon: const Icon(Icons.arrow_drop_down_outlined),
                    elevation: 24,
                    iconSize: 24,
                    underline: Container(
                      height: 2,
                      color: Colors.black,
                    ),
                    onChanged: (newValue){
                      setState(() {
                        selected = newValue;
                      });
                      widget.creditCard.setParcelament(newValue);
                    },
                    items: <int>[1, 2, 3, 4]
                        .map<DropdownMenuItem<int>>((int value) {
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Text('$value x sem juros'),
                      );
                    }).toList(),
                  ),
                )
              ],
            ),
          ),
        );
  }
}
