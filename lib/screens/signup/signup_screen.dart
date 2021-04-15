import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loja_virtual/helpers/validators.dart';
import 'package:loja_virtual/models/user.dart';
import 'package:loja_virtual/models/user_manager.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatelessWidget {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  //controlando os campos
  final User user = User();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.black,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.navigate_before_outlined,
                size: 30, color: Colors.white),
            onPressed: () => Navigator.of(context).pushNamed('/login'),
          ),
          title: const Text('Cadastro'),
          centerTitle: true,
          backgroundColor: Colors.black,
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
                    Column(
                      children: [
                        TextFormField(
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                              hintText: 'Entre com seu nome',
                              labelText: 'Nome completo',
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 20),
                              hintStyle: TextStyle(color: Colors.white),
                              labelStyle: TextStyle(color: Colors.white),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              enabledBorder: borderInput(),
                              focusedBorder: borderInput(),
                              errorBorder: borderInput(),
                              focusedErrorBorder: borderInput(),
                              disabledBorder: borderInput(),
                              suffixIcon: Icon(
                                Icons.email_outlined,
                                color: Colors.white,
                              )),
                          autocorrect: false,
                          enabled: !userManager.loading,
                          validator: (name) {
                            if (name.isEmpty)
                              return 'Campo obrigatório';
                            else if (name.trim().split(' ').length <= 1)
                              return 'Preencha seu nome completo';
                            return null;
                          },
                          onSaved: (name) => user.name = name,
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        TextFormField(
                          enabled: !userManager.loading,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                              hintText: 'Entre com seu e-mail',
                              labelText: 'E-mail',
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 20),
                              hintStyle: TextStyle(color: Colors.white),
                              labelStyle: TextStyle(color: Colors.white),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
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
                            if (email.isEmpty)
                              return 'Campo obrigatório';
                            else if (!emailValid(email))
                              return 'E-mail inválido';
                            return null;
                          },
                          onSaved: (email) => user.email = email,
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                         TextFormField(
                          enabled: !userManager.loading,
                          style: TextStyle(color: Colors.white),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            TelefoneInputFormatter()
                          ],
                          decoration: InputDecoration(
                              hintText: '(99) 99999-9999',
                              labelText: 'Celular',
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 20),
                              hintStyle: TextStyle(color: Colors.white),
                              labelStyle: TextStyle(color: Colors.white),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              enabledBorder: borderInput(),
                              focusedBorder: borderInput(),
                              errorBorder: borderInput(),
                              focusedErrorBorder: borderInput(),
                              disabledBorder: borderInput(),
                              suffixIcon: Icon(
                                Icons.phone,
                                color: Colors.white,
                              )),
                          keyboardType: TextInputType.number,
                          autocorrect: false,
                          validator: (phone) {
                            if (phone.isEmpty)
                              return 'Campo obrigatório';
                            else if (phone.length < 14) 
                            return 'Número inválido';
                            return null;
                          },
                          onSaved: (phone) => user.phone = phone,
                        ),

                        const SizedBox(height: 25,),
                        TextFormField(
                          enabled: !userManager.loading,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                              hintText: 'Entre com sua senha',
                              labelText: 'Senha',
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 20),
                              hintStyle: TextStyle(color: Colors.white),
                              labelStyle: TextStyle(color: Colors.white),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                               enabledBorder: borderInput(),
                              focusedBorder: borderInput(),
                              errorBorder: borderInput(),
                              focusedErrorBorder: borderInput(),
                              disabledBorder: borderInput(),
                              suffixIcon: Icon(
                                Icons.lock_outline,
                                color: Colors.white,
                              )),
                          obscureText: true,
                          autocorrect: false,
                          validator: (senha) {
                            if (senha.isEmpty)
                              return 'Senha obrigatória';
                            else if (senha.length < 6)
                              return 'Senha muito curta';
                            return null;
                          },
                          onSaved: (pass) => user.password = pass,
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        TextFormField(
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                              hintText: 'Confirme sua senha',
                              labelText: 'Confirmação da senha',
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 20),
                              hintStyle: TextStyle(color: Colors.white),
                              labelStyle: TextStyle(color: Colors.white),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              enabledBorder: borderInput(),
                              focusedBorder: borderInput(),
                              errorBorder: borderInput(),
                              focusedErrorBorder: borderInput(),
                              disabledBorder: borderInput(),
                              suffixIcon: Icon(
                                Icons.lock_outline,
                                color: Colors.white,
                              )),
                          autocorrect: false,
                          obscureText: true,
                          enabled: !userManager.loading,
                          validator: (senha) {
                            if (senha.isEmpty)
                              return 'Senha obrigatória';
                            else if (senha.length < 6)
                              return 'Senha muito curta';
                            return null;
                          },
                          onSaved: (pass) => user.confirPass = pass,
                        ),
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
                                  formKey.currentState.save();

                                  if (user.password != user.confirPass) {
                                    return scaffoldKey.currentState
                                        // ignore: deprecated_member_use
                                        .showSnackBar(SnackBar(
                                      content: Text('As senhas não coincidem!'),
                                      backgroundColor: Colors.red,
                                    ));
                                  }
                                  userManager.signUp(
                                      user: user,
                                      onSuccess: () {
                                        Navigator.of(context).pushNamed('/');
                                      },
                                      onFail: (e) {
                                        scaffoldKey.currentState
                                            // ignore: deprecated_member_use
                                            .showSnackBar(SnackBar(
                                          content:
                                              Text('Falha ao cadastrar $e'),
                                          backgroundColor: Colors.red,
                                        ));
                                      });
                                }
                              },
                        color: Colors.transparent,
                        disabledColor: Colors.transparent,
                        textColor: Colors.white,
                        child: userManager.loading
                            ? CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation(Colors.white),
                                    strokeWidth: 0.6,
                              )
                            : Text(
                                'Criar conta',
                                style: TextStyle(fontSize: 18),
                              ),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Já tem uma conta?',
                          style: TextStyle(color: Colors.white),
                        ),
                        GestureDetector(
                            onTap: () {
                              Navigator.of(context)
                                  .pushReplacementNamed('/login');
                            },
                            child: Text(
                              '  Entrar',
                              style: TextStyle(color: Colors.amber[600])
                            ))
                      ],
                    )
                  ],
                ),
              ]);
            }),
          ),
        )),
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
