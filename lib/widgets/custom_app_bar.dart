import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pluto_menu_bar/pluto_menu_bar.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double width;
  const CustomAppBar({Key? key, required this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Platform.isAndroid
        ? AppBar(
            title: const Text("Application Instances"),
          )
        : (!Platform.isMacOS
            ? PlutoMenuBar(menus: [
                PlutoMenuItem(title: "File", children: [
                  PlutoMenuItem(
                    title: "Save Logs",
                  ),
                  PlutoMenuItem(
                    title: "Clear All Logs",
                  )
                ]),
              ])
            : Container());
  }

  @override
  Size get preferredSize => Size(width, 50);
}
