import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loja_virtual/screens/checkout/components/card_text_field.dart';
import 'package:loja_virtual/models/credit_card.dart';

class CardBack extends StatelessWidget {

  CardBack({this.cvvFocus,this.creditCard});

  final FocusNode cvvFocus;
  final CreditCardModel creditCard;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 16,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        height: 200,
        color: Colors.blueGrey,
        child: Column(
          children: [
            Container(
              color: Colors.amber[600],
              height: 40,
              margin: const EdgeInsets.symmetric(vertical: 16),
            ),
            Row(
              children: [
                Expanded(
                  flex: 70,
                  child: Container(
                    margin: const EdgeInsets.only(left: 12),
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                    color: Colors.grey[500],
                    child: CardTextField(
                      hint: '123',
                      maxLength: 3,
                      bold: true,
                      textAlign: TextAlign.end,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      textInputType: TextInputType.number,
                      validator: (cvv) {
                        if (cvv.length != 3) {
                          return 'Inválido';
                        }
                        return null;
                      },
                      focusNode: cvvFocus,
                      onSaved: creditCard.setCVV,
                      inicialValue: creditCard.securityCode,
                    ),
                  ),
                ),
                Expanded(flex: 30, child: Container())
              ],
            )
          ],
        ),
      ),
    );
  }
}
