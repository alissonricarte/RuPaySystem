import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/student_model.dart';

class StudentService {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<void> salvarAluno(StudentModel student, String authId) async {
    final dados = student.toMap(authId);

    print(dados);

    await supabase.from('students').insert(dados);

    print("INSERT realizado.");
  }

  Future<Map<String, dynamic>?> buscarPorEmail(String email) async {
    final response = await supabase
        .from('students')
        .select()
        .eq('email', email)
        .maybeSingle();

    return response;
  }

  Future<void> excluir(String id) async {
    await supabase.from('students').delete().eq('id', id);
  }

  Future<bool> alunoExiste(String id) async {
    final response = await supabase
        .from("students")
        .select("id")
        .eq("id", id)
        .maybeSingle();

    return response != null;
  }
}
