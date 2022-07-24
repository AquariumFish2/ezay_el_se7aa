import 'package:flutter/material.dart';

abstract class TextStyles {
  static TextStyle userNameTextStyle = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: Colors.green.shade800,
  );
  static TextStyle drawerListTileTextStyle = const TextStyle(
    fontSize: 18,
    color: Colors.green,
    fontWeight: FontWeight.w400,
  );
  static TextStyle detailsTextStyle = const TextStyle(
    fontSize: 16,
    color: Colors.green,
    fontWeight: FontWeight.normal
  );
}
