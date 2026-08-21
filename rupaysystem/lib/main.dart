import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app/views/splash/ splash_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  // Teste
  debugPrint("====================================");
  debugPrint("URL: ${dotenv.env['SUPABASE_URL']}");
  debugPrint("KEY: ${dotenv.env['SUPABASE_ANON_KEY']!.substring(0, 20)}...");
  debugPrint("====================================");

  Supabase.instance.client.auth.onAuthStateChange.listen((data) {
    debugPrint("EVENTO: ${data.event}");
    debugPrint("SESSION: ${data.session}");
  });

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
