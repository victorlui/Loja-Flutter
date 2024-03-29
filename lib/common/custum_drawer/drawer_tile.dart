import 'package:flutter/material.dart';
import 'package:loja_virtual/models/page_manager.dart';
import 'package:provider/provider.dart';

class DrawerTile extends StatelessWidget {
  DrawerTile({this.iconData, this.title, this.page});

  final IconData iconData;
  final String title;
  final int page;

  @override
  Widget build(BuildContext context) {
    final int curPage = context.watch<PageManager>().page;
    //final Color primaryColor = Theme.of(context).primaryColor;

    return InkWell(
        onTap: () {
          context.read<PageManager>().setPage(page);
        },
        child: SizedBox(
          height: 60,
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: Icon(
                  iconData,
                  size: 32,
                  color: curPage == page ? Colors.amber[600] : Colors.white70,
                ),
              ),
              Text(title,
                  style: TextStyle(
                      fontSize: 16,
                      color:
                          curPage == page ? Colors.amber[600] : Colors.white70)),
            ],
          ),
        ));
  }
}
