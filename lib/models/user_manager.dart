import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:loja_virtual/helpers/firebase_errors.dart';
import 'package:loja_virtual/models/user.dart';

class UserManager extends ChangeNotifier {
  UserManager() {
    _loadCurrentUser();
  }

  final FirebaseAuth auth = FirebaseAuth.instance;
  final Firestore firestore = Firestore.instance;

  User user;

  bool loading = false;
  void setLoading(bool value) {
    loading = value;
    notifyListeners();
  }

  bool loadingFace = false;
  void setLoadingFace(bool value) {
    loadingFace = value;
    notifyListeners();
  }

  bool get isLoggedIn => user != null;

//realiza o login
  Future<void> signIn({User user, Function onFail, Function onSuccess}) async {
    setLoading(true);
    try {
      final AuthResult result = await auth.signInWithEmailAndPassword(
          email: user.email, password: user.password);

      await _loadCurrentUser(firebaseUser: result.user);

      onSuccess(result.user.uid);
    } on PlatformException catch (e) {
      print(e);
      onFail(getErrorString(e.code));
    }
    setLoading(false);
  }

//carregar usuario ja logado
  Future<void> _loadCurrentUser({FirebaseUser firebaseUser}) async {
    //pegar o usuario logado
    FirebaseUser currentUser = firebaseUser ?? await auth.currentUser();

    if (currentUser != null) {
      final DocumentSnapshot docUser =
          await firestore.collection('users').document(currentUser.uid).get();
      user = User.fromDocument(docUser);
      user.saveToken();
      final docAdmin =
          await firestore.collection('admins').document(user.id).get();

      if (docAdmin.exists) {
        user.admin = true;
      }

      notifyListeners();
    }
  }

  //verificar se ele e administrador
  bool get adminEnabled => user != null && user.admin;

  //cadastrar usuario
  Future<void> signUp({User user, Function onFail, Function onSuccess}) async {
    setLoading(true);
    try {
      final AuthResult result = await auth.createUserWithEmailAndPassword(
          email: user.email, password: user.password);

      user.id = result.user.uid;
      this.user = user;

      await user.saveData();
      user.saveToken();

      onSuccess();
    } on PlatformException catch (e) {
      onFail(getErrorString(e.code));
    }

    setLoading(false);
  }

//funçãos sair
  void signOut() {
    auth.signOut();
    user = null;
    notifyListeners();
  }

  //login com facebook
  Future<void> loginFacebook({Function onFail, Function onSuccess}) async {
    setLoadingFace(true);
    final result = await FacebookLogin().logIn(['email', 'public_profile']);

 
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final credations = FacebookAuthProvider.getCredential(
            accessToken: result.accessToken.token);

        try{
           final authresult = await auth.signInWithCredential(credations);

         print(authresult);

        if (authresult.user != null) {
          final firebaseUser = authresult.user;

          user = User(
              id: firebaseUser.uid,
              name: firebaseUser.displayName,
              email: firebaseUser.email);

          await user.saveData();
          user.saveToken();

          onSuccess();
        }
        } on PlatformException catch(e){
          onFail(getErrorString(e.code));
        }

        break;
      case FacebookLoginStatus.cancelledByUser:
        break;
      case FacebookLoginStatus.error:
        onFail(result.errorMessage);
        break;
    }
    setLoadingFace(false);
  }

  Future<void> resetPassword({String email, Function onSuccess, Function onFail}) async {
    setLoading(true);

    try {
      await auth.sendPasswordResetEmail(email: email);
      onSuccess();
    } on PlatformException catch (e) {
      onFail();
    }

    setLoading(false);
  }
}
