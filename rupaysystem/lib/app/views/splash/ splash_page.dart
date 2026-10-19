import 'dart:async';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/auth_flow.dart';
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

    // Usuário chegou pelo link de "esqueci a senha": vai para a redefinição.
    if (emRecuperacaoSenha) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ResetPasswordPage()),
      );
      return;
    }

    final session = Supabase.instance.client.auth.currentSession;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => session != null ? const MealPage() : const LoginPage(),
      ),
    );
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
