import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_virtual/models/item_size.dart';
import 'package:uuid/uuid.dart';

class Products extends ChangeNotifier {

  final Firestore firestore = Firestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  DocumentReference get firesotreRef => firestore.document('products/$id');
  //criar um pasta onde vai armazenar a imagem
  StorageReference get storageRef => storage.ref().child('products').child(id);

  Products({this.id,this.name,this.description,this.sizes,this.images,this.deleted = false}){
    images = images ?? [];
    sizes = sizes ?? [];
  }

  Products.fromDocument(DocumentSnapshot document) {
    id = document.documentID;
    name = document['name'] as String;
    description = document['description'] as String;
    images = List<String>.from(document.data['images'] as List<dynamic>);
    deleted = (document.data['deleted'] ?? false) as bool;
    sizes = (document.data['sizes'] as List<dynamic> ?? [])
        .map((s) => ItemSize.fromMap(s as Map<String, dynamic>))
        .toList();
  }

  String id;
  String name;
  String description;
  List<String> images;
  List<ItemSize> sizes;
  bool deleted;

  bool _loading = false;
  bool get loading => _loading;
  
  
  set loading(bool value){
    _loading = value;
    notifyListeners();
  }

  List<dynamic> newImages;

  ItemSize _selectedSize;
  ItemSize get selectedSize => _selectedSize;

//seleciona um tamanho de roupa
  set selectedSize(ItemSize value) {
    _selectedSize = value;
    notifyListeners();
  }

//pega o estoque
  int get totalStock {
    int stock = 0;

    for (final size in sizes) {
      stock += size.stock;
    }

    return stock;
  }

//retorna o total estoque
  bool get hasStock {
    return totalStock > 0 && !deleted;
  }

  //pegar o valor base e o menor valor
  num get basePrice {
    num lowest = double.infinity;

    for(final size in sizes){
      if(size.price < lowest)
      lowest = size.price;
    }

    return lowest;
  }

//pega o tamanho se nao retorna null
  ItemSize findSize(String name) {
    try {
      return sizes.firstWhere((s) => s.name == name);
    } catch (e) {
      return null;
    }
  }

  //clone do produtio
  Products clone(){
    return Products(
      id: id,
      name: name,
      description: description,
      images: List.from(images),
      sizes: sizes.map((sizes) => sizes.clone()).toList(),
      deleted: deleted
    );
  }

  @override
  String toString() {
    return 'Product {id: $id, name: $name, description: $description, images: $images, sizes: $sizes, newImages: $newImages}';
  }

  List<Map<String,dynamic>> exportSizeList(){
    return sizes.map((e) => e.toMap()).toList();
  }

  //salvando dados no firebase
  Future<void> save() async{
    loading = true;
    final Map<String,dynamic> data = {
      'name': name,
      'description': description,
      'sizes': exportSizeList(),
      'deleted': deleted
    };

    if(id == null){
     final doc = await firestore.collection('products').add(data);
     id = doc.documentID;
    }else{
      await firesotreRef.updateData(data);
    }

    final List<String> updateImages = [];

      //percorre as novas imagens e verficiar se tem na lista das imagens antigas se não ela adiciona na updateImages
    for(final newImages in newImages){
      if(images.contains(newImages)){
        updateImages.add(newImages as String);
      }else{
        final StorageUploadTask task =  storageRef.child(Uuid().v1()).putFile(newImages as File);
        final StorageTaskSnapshot snapshot = await task.onComplete;
        final String url = await snapshot.ref.getDownloadURL() as String;

        updateImages.add(url);
      }
    }

    //verificar 
    for(final image in images){
      if(!newImages.contains(image) && image.contains('firebase')){
        try{
          final ref = await storage.getReferenceFromUrl(image);
          ref.delete();
        }catch(e){
          debugPrint('Falaha ao debugar $images');
        }

      }
    }

    await firesotreRef.updateData({'images': updateImages});
    images = updateImages;
    loading = false;
  }

  void delete(){
    firesotreRef.updateData({'deleted': true});
  }
}
