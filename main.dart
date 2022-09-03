import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'provider/auth.dart';
import 'provider/bottom_navigationController.dart';
import 'provider/docs/docs.dart';
import 'provider/docs/itemsSearchedInDocs.dart';
import 'provider/normalPost.dart';
import 'provider/patients/patients.dart';
import 'model/role_provider.dart';
import 'provider/docs/searchDocController.dart';
import 'provider/patients/searchPatientsControler.dart';
import 'provider/volanteers.dart';
import 'screens/postscreen/posts/normal_post.dart';
import 'screens/splashscreen/splashscreen.dart';
import 'package:sizer/sizer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orie, deviceType) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (context) => Auth(),
            ),
            ChangeNotifierProvider(
              create: (context) => BottomNavigationController(),
            ),
            ChangeNotifierProvider(
              create: (context) => NormalPostProvider(),
            ),
            ChangeNotifierProvider(
              create: (context) => PatientsProv(),
            ),
            ChangeNotifierProvider(
              create: (context) => Volanteers(),
            ),
            ChangeNotifierProvider(
              create: (context) => Docs(),
            ),
            ChangeNotifierProvider(
              create: (context) => SearchDocController(),
            ),
            ChangeNotifierProvider(
              create: (context) => ItemsSearchedInDocs(),
            ),
            ChangeNotifierProvider(
                create: (context) => SearchPatientsController()),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate
            ],
            supportedLocales: const [Locale('ar', '')],
            title: 'Flutter Demo',
            theme: ThemeData(
              textButtonTheme: TextButtonThemeData(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    Colors.green[50],
                  ),
                ),
              ),
              textTheme: TextTheme(
                headline1: TextStyle(
                  color: Colors.green,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                subtitle1: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                headline2: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              primarySwatch: Colors.green,
              scaffoldBackgroundColor: Colors.white,
              bottomNavigationBarTheme: const BottomNavigationBarThemeData(
                backgroundColor: Colors.green,
                selectedItemColor: Colors.white,
                selectedLabelStyle: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            home: Splash(),
          ),
        );
      },
    );
  }
}
