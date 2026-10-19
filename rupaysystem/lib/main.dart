import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app/core/auth_flow.dart';
import 'app/views/reset_password/reset_password_page.dart';
import 'app/views/splash/ splash_page.dart';

final navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  // O supabase_flutter, na web, já lê o ?code= da URL sozinho e troca pela
  // sessão. Nenhuma tela deve chamar exchangeCodeForSession de novo.
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  Supabase.instance.client.auth.onAuthStateChange.listen((data) {
    debugPrint("EVENTO: ${data.event}");

    if (data.event == AuthChangeEvent.passwordRecovery) {
      emRecuperacaoSenha = true;

      navigatorKey.currentState?.pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const ResetPasswordPage()),
        (route) => false,
      );
    }
  });

  runApp(const RuPaySystem());
}

class RuPaySystem extends StatelessWidget {
  const RuPaySystem({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      home: const SplashPage(),
    );
  }
}
