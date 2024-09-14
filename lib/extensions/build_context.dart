import 'package:flutter/material.dart';

extension ThemeExtension on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => theme.textTheme;
  Orientation get orientation => MediaQuery.of(this).orientation;
  ColorScheme get colorScheme => theme.colorScheme;
  Size get size => MediaQuery.of(this).size;
  double get width => size.width;
  double get height => size.height;
  EdgeInsets get padding => MediaQuery.of(this).padding;
  double get topPadding => padding.top;
  double get bottomPadding => padding.bottom;
  double get leftPadding => padding.left;
  double get rightPadding => padding.right;
  NavigatorState get navigator => Navigator.of(this);
  NavigatorState get rootNavigator => Navigator.of(this, rootNavigator: true);
}
