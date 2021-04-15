import 'package:flutter/material.dart';

class LoginCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.account_circle,
              color: Colors.white,
              size: 100,
            ),
           Padding(
             padding: const EdgeInsets.all(16),
             child:  const Text(
              'Faça login para acessar',
              textAlign: TextAlign.center,
              
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18,color: Colors.white),
            ),
           ),
            // ignore: deprecated_member_use
            RaisedButton(
              color: Colors.white,
              textColor: Theme.of(context).primaryColor,
              child: const Text('LOGIN'),
              onPressed: (){
                Navigator.of(context).pushNamed('/login');
              },
            )
          ],
        ),
      ),
    );
  }
}
