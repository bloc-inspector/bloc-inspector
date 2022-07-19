import 'dart:convert';

import 'package:flutter/material.dart';

class TypeText extends StatelessWidget {
  final dynamic text;
  final Color? colorOverride;

  const TypeText(
    this.text, {
    Key? key,
    this.colorOverride,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SelectableText(
      _processed,
      style: TextStyle(
        color: _color,
      ),
    );
  }

  String get _processed {
    if (text is List || text is Map) {
      JsonEncoder encoder = const JsonEncoder.withIndent('    ');
      return encoder.convert(text);
    }

    return text.toString();
  }

  Color? get _color {
    if (colorOverride != null) return colorOverride;
    if (text is bool) return Colors.purple;
    if (text is String) return Colors.brown;
    if (text is List || text is Map) return Colors.brown;
    return null;
  }
}
