import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cpf_cnpj_validator/cpf_validator.dart';
import 'package:loja_virtual/models/user_manager.dart';  
import 'package:provider/provider.dart';

class CPFField extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final userManager = context.watch<UserManager>();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Text(
          'CPF',
          textAlign: TextAlign.start,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
          TextFormField(
            initialValue: userManager.user.cpf,
            decoration: const InputDecoration(hintText: '000.000.000-00',isDense: true),
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              CpfInputFormatter()
            ],
            validator: (cpf){
              print(cpf);
              if(cpf.isEmpty) return 'Campo Obrigatório';
              else if(cpf.length != 14) return 'CPF Inválido';
              else if(!CPFValidator.isValid(cpf)) return 'CPF Inválido';
              return null;
            },
            onSaved: userManager.user.setCpf,
          )
        ],)
      ),
    );
  }
}
