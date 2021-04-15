import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loja_virtual/common/custum_drawer/custom_drawer.dart';
import 'package:loja_virtual/models/cart_manager.dart';
import 'package:loja_virtual/models/home_manager.dart';
import 'package:loja_virtual/models/user_manager.dart';
import 'package:loja_virtual/screens/home/components/section_list.dart';
import 'package:loja_virtual/screens/home/components/section_staggered.dart';
import 'package:provider/provider.dart';

import 'components/add_section_widgtes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: () async  => false,
          child: Scaffold(
          drawer: CustomDrawer(),
          body: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.light,
                      child: Stack(
              children: [
                Container(
                  color: Colors.black87,
                ),
                CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      backgroundColor: Colors.transparent,
                      snap: true,
                      floating: true,
                      elevation: 0,
                      flexibleSpace: const FlexibleSpaceBar(
                        title: Text('CB Store'),
                        centerTitle: true,
                      ),
                      actions: [
                        Consumer<CartManager>(
                          builder: (_, cartManager, __) {

                            if(cartManager.items.length == 0){
                              return IconButton(
                              icon: Icon(Icons.shopping_cart),
                              color: Colors.white,
                              onPressed: () {
                                Navigator.of(context).pushNamed('/cart');
                              },
                            );
                            }
                            return Badge(
                            badgeColor: Colors.amber[600],
                             position: BadgePosition(start: 20,top:0),
                              badgeContent: Text('${cartManager.items.length}',style: TextStyle(color: Colors.white),),
                                child: IconButton(
                              icon: Icon(Icons.shopping_cart),
                              color: Colors.white,
                              onPressed: () {
                                Navigator.of(context).pushNamed('/cart');
                              },
                            ),);
                          },
                        ),
                        Consumer2<UserManager, HomeManager>(
                            builder: (_, userManager, homeManager, __) {
                          if (userManager.adminEnabled && !homeManager.loading) {
                            if (homeManager.editing) {
                              return PopupMenuButton(
                                  onSelected: (e) {
                                    if (e == 1) {
                                      homeManager.saveEditing();
                                    } else {
                                      homeManager.discartEditing();
                                    }
                                  },
                                  itemBuilder: (_) => [
                                        PopupMenuItem(
                                          child: Text('Salvar'),
                                          value: 1,
                                        ),
                                        PopupMenuItem(
                                            child: Text('Descartar'), value: 2)
                                      ]);
                            } else {
                              return IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: homeManager.enterEditing,
                              );
                            }
                          } else
                            return Container();
                        })
                      ],
                    ),
                    Consumer<HomeManager>(
                      builder: (_, homeManager, __) {
                        if (homeManager.loading) {
                          return SliverToBoxAdapter(
                            child: LinearProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(Colors.white),
                              backgroundColor: Colors.transparent,
                            ),
                          );
                        }
                        final List<Widget> children =
                            homeManager.sections.map<Widget>((section) {
                          switch (section.type) {
                            case 'Staggered':
                              return SectionStaggered(section);
                            case 'List':
                              return SectionList(section);
                            default:
                              return Container();
                          }
                        }).toList();

                        if (homeManager.editing) children.add(AddSectionWidget());

                        return SliverList(
                          delegate: SliverChildListDelegate(children),
                        );
                      },
                    )
                  ],
                ),
              ],
            ),
          )),
    );
  }
}
