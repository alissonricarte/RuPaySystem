import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileService {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<void> atualizarPerfil({
    required String userId,
    required String username,
    required String? fotoUrl,
  }) async {
    await supabase
        .from('students')
        .update({'username': username, 'profile_photo_url': fotoUrl})
        .eq('id', userId);
  }

  Future<Map<String, dynamic>?> buscarPerfil(String userId) async {
    final response = await supabase
        .from('students')
        .select('username, profile_photo_url')
        .eq('id', userId)
        .maybeSingle();

    return response;
  }

  Future<String> uploadProfileImage({
    required String userId,
    required Uint8List bytes,
  }) async {
    final path = '$userId.jpg';

    await supabase.storage
        .from('profile-images')
        .uploadBinary(
          path,
          bytes,
          fileOptions: const FileOptions(
            upsert: true,
            contentType: 'image/jpeg',
          ),
        );

    final url = supabase.storage.from('profile-images').getPublicUrl(path);

    return url;
  }

  Future<void> removerImagemPerfil(String userId) async {
    final removidos = await supabase.storage.from('profile-images').remove([
      '$userId.jpg',
    ]);

    // Se a política de storage não permitir DELETE, o Supabase não dá erro:
    // ele só devolve uma lista vazia.
    if (removidos.isEmpty) {
      debugPrint('Nenhum arquivo removido do storage (confira a policy).');
    }
  }
}
