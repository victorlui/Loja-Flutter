import 'package:flutter/material.dart';
import 'package:loja_virtual/helpers/validators.dart';
import 'package:loja_virtual/models/user.dart';
import 'package:loja_virtual/models/user_manager.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.navigate_before_outlined,
              size: 30, color: Colors.white),
          onPressed: () => Navigator.of(context).pushNamed('/'),
        ),
        backgroundColor: Colors.black,
        brightness: Brightness.light,
        centerTitle: true,
        title: const Text('Entrar'),
      ),
      body: SafeArea(
          child: Container(
        padding: const EdgeInsets.all(20),
        width: double.infinity,
        child: Form(
          key: formKey,
          child: Consumer<UserManager>(builder: (_, userManager, __) {
            return ListView(shrinkWrap: true, children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 40,
                  ),
                  Text(
                    'Faça o login para continuar.',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 60,
                  ),
                  Column(
                    children: [
                      TextFormField(
                        controller: emailController,
                        enabled: !userManager.loading,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                            hintText: 'Entre com seu e-mail',
                            labelText: 'E-mail',
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 30, vertical: 20),
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
                        validator: (email) {
                          if (!emailValid(email)) return 'E-mail inválido';
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      TextFormField(
                        controller: passController,
                        enabled: !userManager.loading,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                            hintText: 'Entre com sua senha',
                            labelText: 'Senha',
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 30, vertical: 20),
                            hintStyle: TextStyle(color: Colors.white),
                            labelStyle: TextStyle(color: Colors.white),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            enabledBorder: borderInput(),
                            focusedBorder: borderInput(),
                            errorBorder: borderInput(),
                            focusedErrorBorder: borderInput(),
                            border: borderInput(),
                            disabledBorder: borderInput(),
                            suffixIcon: Icon(
                              Icons.lock_outline,
                              color: Colors.white,
                            )),
                        autocorrect: false,
                        obscureText: true,
                        validator: (senha) {
                          if (senha.isEmpty || senha.length < 6)
                            return 'Senha inválida';
                          return null;
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamed('/recovery');
                          },
                          child: Text(
                            'Esqueci minha senha',
                            style: TextStyle(color: Colors.amber[600]),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 60,
                  ),
                  Container(
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
                      onPressed: userManager.loading
                          ? null
                          : () {
                              if (formKey.currentState.validate()) {
                                userManager.signIn(
                                    user: User(
                                        email: emailController.text,
                                        password: passController.text),
                                    onFail: (e) {
                                      scaffoldKey.currentState
                                          // ignore: deprecated_member_use
                                          .showSnackBar(SnackBar(
                                        content: Text('Falha ao entrar: $e'),
                                        backgroundColor: Colors.red,
                                      ));
                                    },
                                    onSuccess: (s) {
                                      Navigator.of(context).pushNamed('/');
                                    });
                              }
                            },
                      color: Colors.transparent,
                      disabledColor: Colors.transparent,
                      textColor: Colors.white,
                      child: userManager.loading
                          ? CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(
                                Colors.white,
                              ),
                              strokeWidth: 0.6,
                            )
                          : Text(
                              'Continuar',
                              style: TextStyle(fontSize: 15),
                            ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      userManager.loginFacebook(onFail: (e) {
                        // ignore: deprecated_member_use
                        scaffoldKey.currentState.showSnackBar(SnackBar(
                          content: Text('Falha ao entrar: $e'),
                          backgroundColor: Colors.red,
                        ));
                      }, onSuccess: (s) {
                        Navigator.of(context).pop();
                      });
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                          color: Colors.white, shape: BoxShape.circle),
                      child: Image.asset('assets/images/facebook.png'),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Não tem uma conta?',
                        style: TextStyle(color: Colors.white),
                      ),
                      GestureDetector(
                          onTap: () {
                            Navigator.of(context)
                                .pushReplacementNamed('/signup');
                          },
                          child: Text(
                            '  Cadastre-se',
                            style: TextStyle(color: Colors.amber[600]),
                          ))
                    ],
                  )
                ],
              ),
            ]);
          }),
        ),
      )),
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
