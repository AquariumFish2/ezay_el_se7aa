import 'package:docs/controllers/login/cityLoginController.dart';
import 'package:docs/controllers/login/loginController.dart';
import 'package:docs/controllers/login/roleLoginController.dart';
import 'package:docs/controllers/login/specLoginController.dart';
import 'package:docs/screens/home_screen/home_screen.dart';
import 'package:docs/screens/loginScreen/LoginScreen.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';
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
      builder: (context, oriantation, devType) => MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => LoginController()),
          ChangeNotifierProvider(create: (context) => RoleLoginController()),
          ChangeNotifierProvider(create: (context) => CityLoginController()),
          ChangeNotifierProvider(create: (context) => SpecLoginController()),
        ],
        child: MaterialApp(
          home: const Splash(),
          theme: ThemeData(primarySwatch: Colors.green),
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}
