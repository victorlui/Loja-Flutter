import 'package:flutter/material.dart';
import 'package:loja_virtual/models/user_manager.dart';
import 'package:provider/provider.dart';

class RecoverScree extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Recuperar senha'),
        backgroundColor: Colors.black,
        brightness: Brightness.light,
        leading: IconButton(
          icon: Icon(Icons.navigate_before_outlined,
              size: 30, color: Colors.white),
          onPressed: () => Navigator.of(context).pushNamed('/login'),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            width: double.infinity,
            child: Text(
              'Informe seu e-mail para continuar',
              style: TextStyle(color: Colors.white, fontSize: 20),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: TextFormField(
              style: TextStyle(color: Colors.white),
              controller: emailController,
              decoration: InputDecoration(
                  hintText: 'Entre com seu e-mail',
                  labelText: 'E-mail',
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  hintStyle: TextStyle(color: Colors.white),
                  labelStyle: TextStyle(color: Colors.white),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  enabledBorder: borderInput(),
                  focusedBorder: borderInput(),
                  errorBorder: borderInput(),
                  focusedErrorBorder: borderInput(),
                  disabledBorder: borderInput(),
                  suffixIcon: Icon(
                    Icons.email_outlined,
                    color: Colors.white,
                  )),
              keyboardType: TextInputType.emailAddress,
              autocorrect: false,
            ),
          ),
          Consumer<UserManager>(builder: (_, userManager, __) {
            if (userManager.loading) {
              return Container(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                  strokeWidth: 0.6,
                ),
              );
            }
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              width: double.infinity,
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(28)),
              child:
                  // ignore: deprecated_member_use
                  RaisedButton(
                padding: const EdgeInsets.symmetric(vertical: 15),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                onPressed: () {
                  userManager.resetPassword(
                      email: emailController.text,
                      onSuccess: () {
                        scaffoldKey.currentState
                            // ignore: deprecated_member_use
                            .showSnackBar(SnackBar(
                          content: Text(
                            'Confira sua caixa de email',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          backgroundColor: Colors.amber[600],
                        ));
                      },
                      onFail: () {
                        scaffoldKey.currentState
                            // ignore: deprecated_member_use
                            .showSnackBar(SnackBar(
                          content: Text(
                            'Verifique seu email ou sua conexão com a internet',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          backgroundColor: Colors.red,
                        ));
                      });
                },
                color: Colors.transparent,
                disabledColor: Colors.transparent,
                textColor: Colors.white,
                child: Text(
                  'Recuperar',
                  style: TextStyle(fontSize: 15),
                ),
              ),
            );
          })
        ],
      ),
    );
  }

  //coloca uma borda no input
  OutlineInputBorder borderInput() {
    return OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
        borderRadius: BorderRadius.circular(28),
        gapPadding: 10);
  }
}
