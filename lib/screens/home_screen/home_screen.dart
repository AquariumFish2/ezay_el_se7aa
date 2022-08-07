import 'package:docs/screens/home_screen/widgets/drawer/drawer.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer:const AppDrawer(),
      appBar: AppBar(title:const Text('Home screen'),),
      body: Container(),
    );
  }
}
