import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:docs/screens/home_screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class Splash extends StatelessWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splashIconSize: 60.w,
      duration: 3000,
      backgroundColor: Colors.white,
      splash: Image.asset('assets/images/logo.jpg'),
      nextScreen: const HomeScreen(),
    );
  }
}
