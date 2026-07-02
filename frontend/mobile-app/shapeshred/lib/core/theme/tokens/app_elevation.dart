import 'package:flutter/material.dart';

class AppElevation {
  static const List<BoxShadow> none = [];
  static const List<BoxShadow> small = [
    BoxShadow(color: Color(0x1A000000), blurRadius: 4, offset: Offset(0, 2)),
  ];
  static const List<BoxShadow> medium = [
    BoxShadow(color: Color(0x1A000000), blurRadius: 8, offset: Offset(0, 4)),
  ];
  static const List<BoxShadow> large = [
    BoxShadow(color: Color(0x1A000000), blurRadius: 16, offset: Offset(0, 8)),
  ];
}
