import 'package:flutter/material.dart';
import 'package:loja_virtual/common/custom_icon_button.dart';
import 'package:loja_virtual/models/item_size.dart';

class EditItemSize extends StatelessWidget {
  EditItemSize(
      {Key key, this.size, this.onRemove, this.onMoveUp, this.onMoveDown})
      : super(key: key);

  final ItemSize size;
  final VoidCallback onRemove;
  final VoidCallback onMoveUp;
  final VoidCallback onMoveDown;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 30,
          child: TextFormField(
            validator: (name) {
              if (name.isEmpty) return 'Inválido';
              return null;
            },
            initialValue: size.name,
            decoration: InputDecoration(labelText: 'Título', isDense: true),
            onChanged: (name) => size.name = name,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Expanded(
          flex: 30,
          child: TextFormField(
              validator: (stock) {
                if (int.tryParse(stock) == null) return 'Inválido';

                return null;
              },
              initialValue: size.stock?.toString(),
              decoration: InputDecoration(labelText: 'Estoque', isDense: true),
              keyboardType: TextInputType.number,
              onChanged: (stock) => size.stock = int.tryParse(stock)),
        ),
        const SizedBox(
          width: 4,
        ),
        Expanded(
          flex: 40,
          child: TextFormField(
              validator: (price) {
                if (num.tryParse(price) == null) return 'Inválido';

                return null;
              },
              initialValue: size.price?.toStringAsFixed(2),
              decoration: InputDecoration(
                  labelText: 'Preço', isDense: true, prefixText: 'R\$ '),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onChanged: (price) => size.price = num.tryParse(price)),
        ),
        CustomIconButton(
          iconData: Icons.remove,
          color: Colors.red,
          onTap: onRemove,
        ),
        CustomIconButton(
          iconData: Icons.arrow_drop_up,
          color: Colors.black,
          onTap: onMoveUp,
        ),
        CustomIconButton(
          iconData: Icons.arrow_drop_down,
          color: Colors.black,
          onTap: onMoveDown,
        )
      ],
    );
  }
}
