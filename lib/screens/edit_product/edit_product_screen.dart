import 'package:flutter/material.dart';
import 'package:loja_virtual/models/products.dart';
import 'package:loja_virtual/models/products_manager.dart';
import 'package:loja_virtual/screens/edit_product/components/images_form.dart';
import 'package:provider/provider.dart';

import 'components/sizes_form.dart';

class EditProductScreen extends StatelessWidget {
  EditProductScreen(Products p)
      : editing = p != null,
        product = p != null ? p.clone() : Products();

  final Products product;
  final bool editing;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: product,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(editing ? 'Editar Produto' : 'Criar Produto'),
          centerTitle: true,
          actions: [
            if(editing)
            IconButton(icon: Icon(Icons.delete,color: Colors.red,), onPressed: (){
              context.read<ProductsManager>().deleteProduct(product);
              Navigator.of(context).pop();
            })
          ],
        ),
        body: Form(
          key: formKey,
          child: ListView(
            children: [
              ImagesForm(product),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      initialValue: product.name,
                      decoration: const InputDecoration(
                          hintText: 'Título', border: InputBorder.none),
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                      validator: (name) {
                        if (name.length < 6) return 'Título muito curto';
                        return null;
                      },
                      onSaved: (name) => product.name = name,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        'R\$ ....',
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 22),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(
                          top: 16,
                        ),
                        child: Text(
                          'Descrição',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        )),
                    TextFormField(
                      initialValue: product.description,
                      maxLines: null,
                      decoration: const InputDecoration(
                          hintText: 'Descrição', border: InputBorder.none),
                      style: TextStyle(
                        fontSize: 16,
                      ),
                      validator: (description) {
                        if (description.length < 10)
                          return 'Descrição muito curta';
                        return null;
                      },
                      onSaved: (description) =>
                          product.description = description,
                    ),
                    SizesForm(product),
                    const SizedBox(height: 20),
                    Consumer<Products>(builder: (_, productManager, __) {
                      return SizedBox(
                        height: 44,
                        // ignore: deprecated_member_use
                        child: RaisedButton(
                          onPressed: !productManager.loading
                              ? () async {
                                  if (formKey.currentState.validate()) {
                                    formKey.currentState.save();
                                   await product.save();

                                   context.read<ProductsManager>().update(product);

                                   Navigator.of(context).pop();
                                  }
                                }
                              : null,
                          color: Theme.of(context).primaryColor,
                          disabledColor:
                              Theme.of(context).primaryColor.withAlpha(100),
                          child: productManager.loading
                              ? CircularProgressIndicator(
                                  valueColor:
                                      AlwaysStoppedAnimation(Colors.white),
                                )
                              : const Text(
                                  'Salvar',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                        ),
                      );
                    })
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
