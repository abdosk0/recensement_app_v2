import 'package:flutter/material.dart';
import 'package:recensement_app_test/pages/homePage.dart';
import 'package:recensement_app_test/pages/menageForm.dart';
import 'package:recensement_app_test/pages/menu.dart';
import 'package:recensement_app_test/pages/splashScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Recensement Demo',
      home: const SplashScreen(),
      routes: {
        "home": (context) => const HomePage(),
        "menu": (context) => const Menu(),
        "menage": (context) => const MenageForm(),
      },
    );
  }
}
