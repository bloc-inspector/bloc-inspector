import 'package:bloc_inspector_client/extensions/build_context.dart';
import 'package:flutter/material.dart';

class ColorGate {
  final BuildContext context;
  final Color? defaultColor;
  final Color? darkModeColor;

  ColorGate({
    required this.context,
    this.defaultColor,
    this.darkModeColor = Colors.white,
  });

  Color? get color {
    return context.theme.brightness == Brightness.dark
        ? darkModeColor
        : defaultColor;
  }
}
