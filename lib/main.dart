import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const PropNextMobileApp());
}

class PropNextMobileApp extends StatelessWidget {
  const PropNextMobileApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PropNext Industrial',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF050811),
        fontFamily: 'sans-serif',
      ),
      // Inicia con el Splash Screen de 4 segundos
      home: const SplashScreen(),
    );
  }
}