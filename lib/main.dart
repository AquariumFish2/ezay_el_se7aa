import 'package:docs/screens/home_screen/home_screen.dart';
import 'package:docs/screens/splash_screen/splash_screen.dart';
import "package:flutter/material.dart";
import 'package:responsive_sizer/responsive_sizer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (context,orientation,screenType) {
        return  MaterialApp(
          debugShowCheckedModeBanner: false,
          home:const Splash(),
          theme: ThemeData(
            primarySwatch: Colors.green
          ),
        );
      }
    );
  }
}
