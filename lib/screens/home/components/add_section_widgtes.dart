import 'package:flutter/material.dart';
import 'package:loja_virtual/models/home_manager.dart';
import 'package:loja_virtual/models/section.dart';
import 'package:provider/provider.dart';

class AddSectionWidget extends StatelessWidget {
  const AddSectionWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final homeManager = context.watch<HomeManager>();

    return Row(
      children: [
        Expanded(
          // ignore: deprecated_member_use
          child: FlatButton(
            child: const Text('Adicionar lista'),
            onPressed: () {
              homeManager.addSection(Section(type: 'List'));
            },
            textColor: Colors.white,
          ),
        ),
        Expanded(
          // ignore: deprecated_member_use
          child: FlatButton(
            child: const Text('Adicionar Grade'),
            onPressed: () {
              homeManager.addSection(Section(type: 'Staggered'));
            },
            textColor: Colors.white,
          ),
        )
      ],
    );
  }
}
