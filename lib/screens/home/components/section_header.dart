import 'package:flutter/material.dart';
import 'package:loja_virtual/common/custom_icon_button.dart';
import 'package:loja_virtual/models/home_manager.dart';
import 'package:loja_virtual/models/section.dart';
import 'package:provider/provider.dart';

class SectionHeader extends StatelessWidget {
  SectionHeader(this.section);

  final Section section;

  @override
  Widget build(BuildContext context) {
    final homeManager = context.watch<HomeManager>();

    if (homeManager.editing) {
      return Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: section.name,
                    decoration: InputDecoration(
                      hintText: 'Título',
                      hintStyle: TextStyle(color: Colors.amber[600]),
                      isDense: true,
                      border: InputBorder.none,
                    ),
                    style: TextStyle(
                      color: Colors.amber[600],
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                    ),
                    onChanged: (text) => section.name = text,
                  ),
                ),
                CustomIconButton(
                  iconData: Icons.remove,
                  color: Colors.white,
                  onTap: () {
                    homeManager.removeSection(section);
                  },
                ),
              ],
            ),
            if (section.error != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  section.error,
                  style: TextStyle(color: Colors.red),
                ),
              )
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          section.name ?? "Título da seção",
          style: TextStyle(
              color: Colors.amber[600], fontWeight: FontWeight.w800, fontSize: 18),
        ),
      );
    }
  }
}
