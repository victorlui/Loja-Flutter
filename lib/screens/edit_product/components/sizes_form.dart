import 'package:flutter/material.dart';
import 'package:loja_virtual/common/custom_icon_button.dart';
import 'package:loja_virtual/models/item_size.dart';
import 'package:loja_virtual/models/products.dart';
import 'package:loja_virtual/screens/edit_product/components/edit_item_size.dart';

class SizesForm extends StatelessWidget {
  SizesForm(this.product);

  final Products product;

  @override
  Widget build(BuildContext context) {
    return FormField<List<ItemSize>>(
      validator: (sizes) {
        if(sizes.isEmpty)
        return 'Insira um tamanho';
        return null;
      },
      initialValue: product.sizes,
      builder: (state) {
        return Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Tamanhos',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
                CustomIconButton(
                  iconData: Icons.add,
                  color: Colors.black,
                  onTap: () {
                    state.value.add(ItemSize());
                    state.didChange(state.value);
                  },
                )
              ],
            ),
            Column(
              children: state.value.map((size) {
                return EditItemSize(
                  key: ObjectKey(size),
                  size: size,
                  onRemove: () {
                    state.value.remove(size);
                    state.didChange(state.value);
                  },
                  onMoveUp: size != state.value.first ?  () {
                    final index = state.value.indexOf(size);
                    state.value.remove(size);

                    state.value.insert(index-1, size);
                     state.didChange(state.value);
                  }: null ,
                  onMoveDown: size != state.value.last ? () {
                    //pegar o indice
                    final index = state.value.indexOf(size);
                    state.value.remove(size);

                    state.value.insert(index+1, size);
                    state.didChange(state.value);
                  }: null,
                );
              }).toList(),
            ),
            if (state.hasError)
                Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.only(top: 16, left: 16),
                  child: Text(
                    state.errorText,
                    style: TextStyle(color: Colors.red, fontSize: 18),
                  ),
                )
          ],
        );
      },
    );
  }
}
