import 'package:docs/screens/home_screen/home_screen.dart';
import "package:flutter/material.dart";

void main() {}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomeScreen(),
    );
  }
}
