import 'package:flutter/material.dart';
import 'app/views/splash/ splash_page.dart';

void main() {
  runApp(const RuPaySystem());
}

class RuPaySystem extends StatelessWidget {
  const RuPaySystem({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      home: const SplashPage(),
    );
  }
}