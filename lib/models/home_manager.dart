import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_virtual/models/section.dart';

class HomeManager extends ChangeNotifier {
  final Firestore firestore = Firestore.instance;

  //variavel tipo Section para a lista
  List<Section> _sections = [];
  //clone
  List<Section> _editingSections = [];

  bool editing = false;
  bool loading = false;

  //carregar todos os produtos qdo inicia
  HomeManager() {
    _loadSections();
  }

  //buscando a lista no firebase
  Future<void> _loadSections() async {
    //fica escutando as alterações em tempo real
    firestore.collection('home').orderBy('pos').snapshots().listen((snapshot) {
      //limpa as seções
      _sections.clear();
      //pega cada um dos documentos snapshot
      for (final DocumentSnapshot document in snapshot.documents) {
        _sections.add(Section.fromDocument(document));
      }

      notifyListeners();
    });
  }

  List<Section> get sections {
    if(editing){
      return _editingSections;
    }else{
      return _sections;
    }
  }

  
  //verificar se esta editando ou não
  void enterEditing(){
    editing = true;
    _editingSections = _sections.map((s) => s.clone()).toList();
    notifyListeners();
  }

  //savar as alterações
  Future<void> saveEditing() async {
    bool valid = true;
    //validação
    for(final section in _editingSections){
      if(!section.valid()) valid = false;
    }

   loading =true;
    notifyListeners();
    if(!valid) return;

  int pos = 0;
    //salvamento
   for(final section in _editingSections)  {
     await section.save(pos);
     pos++;
   }

   for(final section in List.from(_sections)){
     if(!_editingSections.any((element) => element.id == section.id)){
       await section.delete();
     }
   }

   loading = false;
 
   editing = false;
   notifyListeners();
  }

  void discartEditing(){
    editing = false;
    notifyListeners();
  }

//adicionar secao na tela home
  void addSection(Section section){
    _editingSections.add(section);
    notifyListeners();
  }

  //remover a secao na tela homr
  void removeSection(Section section){
    _editingSections.remove(section);
    notifyListeners();
  }
}
