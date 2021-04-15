import 'package:flutter/material.dart';
import 'package:loja_virtual/models/page_manager.dart';
import 'package:loja_virtual/models/user_manager.dart';
import 'package:provider/provider.dart';

class CustomDrawerHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
          padding: const EdgeInsets.fromLTRB(32, 24, 16, 8),
          height: 220,
          child: Consumer<UserManager>(
            builder: (_, userManager, __) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    width: double.infinity,
                    child: Image.asset(
                      'assets/images/caio.png',
                      fit: BoxFit.contain,
                      width: 70,
                      height: 120,
                    ),
                  ),
                  Text(
                    'Olá, ${userManager.user?.name ?? ''}',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white70),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (userManager.isLoggedIn) {
                        context.read<PageManager>().setPage(0);
                        userManager.signOut();
                      } else {
                        Navigator.of(context).pushNamed('/login');
                      }
                    },
                    child: Text(
                      userManager.isLoggedIn
                          ? 'Sair'
                          : 'Entrar ou Cadastre-se',
                      style: TextStyle(
                        color: Colors.amber[600],
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              );
            },
          )),
    );
  }
}
