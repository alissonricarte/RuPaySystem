import 'dart:async';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../login/login_page.dart';
import '../meal/meal_page.dart';
import '../reset_password/reset_password_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _verificarSessao();
  }

  Future<void> _verificarSessao() async {
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    final uri = Uri.base;
    final code = uri.queryParameters['code'];

    if (code != null) {
      try {
        await Supabase.instance.client.auth.exchangeCodeForSession(code);

        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const ResetPasswordPage()),
        );

        return;
      } catch (e) {
        print("Erro ao recuperar sessão: $e");
      }
    }

    final session = Supabase.instance.client.auth.currentSession;

    if (session != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MealPage()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image(
          image: AssetImage('lib/app/assets/img/Imagem1.png'),
          width: 220,
        ),
      ),
    );
  }
}
