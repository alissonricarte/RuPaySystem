import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/student_model.dart';

class AuthService {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<void> cadastrar(StudentModel student, String senha) async {
    try {
      final response = await supabase.auth.signUp(
        email: student.email,
        password: senha,
        data: {
          "full_name": student.fullName,
          "username": student.username,
          "registration": student.registration,
          "campus": student.campus,
          "course": student.course,
        },
      );

      if (response.user == null) {
        throw Exception("Erro ao criar usuário.");
      }

      print("========== SIGN UP ==========");
      print("USER ID: ${response.user!.id}");
      print("EMAIL: ${response.user!.email}");
      print("EMAIL CONFIRMADO: ${response.user!.emailConfirmedAt}");
      print("=============================");
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  /// URL para onde o link do e-mail leva o usuário.
  /// Na web usa a origem atual (qualquer porta funciona).
  String get _urlRedirecionamento =>
      kIsWeb ? Uri.base.origin : 'http://localhost:3000';

  /// Envia o e-mail com o link de redefinição de senha.
  Future<void> recuperarSenha(String email) async {
    try {
      await supabase.auth.resetPasswordForEmail(
        email,
        redirectTo: _urlRedirecionamento,
      );
    } on AuthException catch (e) {
      print("MESSAGE: ${e.message}");
      print("STATUS: ${e.statusCode}");
      print("CODE: ${e.code}");
      rethrow;
    }
  }

  Future<bool> login({required String email, required String password}) async {
    try {
      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      return response.user != null;
    } on AuthException catch (e) {
      print(e.message);
      return false;
    }
  }

  Future<void> logout() async {
    await supabase.auth.signOut();
  }

  User? get usuarioAtual => supabase.auth.currentUser;
}
