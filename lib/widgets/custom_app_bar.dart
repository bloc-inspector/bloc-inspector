import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pluto_menu_bar/pluto_menu_bar.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double width;
  final String? title;
  const CustomAppBar({
    Key? key,
    required this.width,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Platform.isAndroid
        ? AppBar(
            title: title != null ? Text(title!) : null,
          )
        : PlutoMenuBar(menus: [
            PlutoMenuItem(title: "File", children: [
              PlutoMenuItem(
                title: "Save Logs",
              ),
              PlutoMenuItem(
                title: "Clear All Logs",
              )
            ]),
          ]);
  }

  @override
  Size get preferredSize => Size(width, 50);
}
