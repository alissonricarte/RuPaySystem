import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../services/profile_service.dart';

class ProfileViewModel extends ChangeNotifier {
  final SupabaseClient supabase = Supabase.instance.client;
  final ProfileService profileService = ProfileService();

  // ============================================================
  // ESTADOS
  // ============================================================

  bool carregando = false;
  bool salvando = false;
  bool editandoUsername = false;

  String? fotoUrl;
  String? username;

  XFile? fotoSelecionada;
  Uint8List? fotoBytes;

  // ============================================================
  // USUÁRIO LOGADO
  // ============================================================

  User? get user => supabase.auth.currentUser;

  // ============================================================
  // CARREGAR PERFIL
  // ============================================================

  Future carregarPerfil() async {
    final currentUser = user;

    if (currentUser == null) {
      debugPrint('USUÁRIO NÃO LOGADO');
      return;
    }

    try {
      carregando = true;
      notifyListeners();

      debugPrint('====================================');
      debugPrint('CARREGANDO PERFIL');
      debugPrint('USER ID: ${currentUser.id}');
      debugPrint('====================================');

      final perfil = await profileService.buscarPerfil(currentUser.id);

      debugPrint('====================================');
      debugPrint('PERFIL ENCONTRADO');
      debugPrint('$perfil');
      debugPrint('USERNAME BANCO: ${perfil?['username']}');
      debugPrint('FOTO BANCO: ${perfil?['profile_photo_url']}');
      debugPrint('====================================');

      if (perfil != null) {
        username = perfil['username']?.toString();
        fotoUrl = perfil['profile_photo_url']?.toString();
      }

      username ??= currentUser.userMetadata?['username']?.toString() ?? '';

      debugPrint('====================================');
      debugPrint('VIEWMODEL');
      debugPrint('USERNAME: $username');
      debugPrint('FOTO URL: $fotoUrl');
      debugPrint('====================================');
    } catch (e) {
      debugPrint('====================================');
      debugPrint('ERRO AO CARREGAR PERFIL');
      debugPrint('$e');
      debugPrint('====================================');
    } finally {
      carregando = false;
      notifyListeners();
    }
  }

  Future<void> selecionarFoto() async {
    try {
      final ImagePicker imagePicker = ImagePicker();

      final XFile? imagem = await imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 1000,
        maxHeight: 1000,
      );

      if (imagem == null) {
        return;
      }

      final bytes = await imagem.readAsBytes();

      fotoSelecionada = imagem;
      fotoBytes = bytes;

      debugPrint('====================================');
      debugPrint('FOTO SELECIONADA');
      debugPrint('Nome: ${imagem.name}');
      debugPrint('Tamanho: ${bytes.length} bytes');
      debugPrint('====================================');

      notifyListeners();
    } catch (e) {
      debugPrint('====================================');
      debugPrint('ERRO AO SELECIONAR FOTO');
      debugPrint('$e');
      debugPrint('====================================');

      rethrow;
    }
  }

  // ============================================================
  // ATUALIZAR ESTADO DO USERNAME
  // ============================================================

  void alterarUsername(String valor) {
    username = valor;
    notifyListeners();
  }

  // ============================================================
  // ATIVAR E DESATIVAR EDIÇÃO
  // ============================================================

  void iniciarEdicaoUsername() {
    editandoUsername = true;
    notifyListeners();
  }

  void cancelarEdicaoUsername() {
    editandoUsername = false;
    notifyListeners();
  }

  // ============================================================
  // SALVAR PERFIL
  // ============================================================

  Future<void> salvarPerfil(String novoUsername) async {
    final currentUser = user;

    if (currentUser == null) {
      throw Exception('Usuário não está logado.');
    }

    final usernameLimpo = novoUsername.trim();

    if (usernameLimpo.isEmpty) {
      throw Exception('Digite um username.');
    }

    try {
      salvando = true;
      notifyListeners();

      debugPrint('====================================');
      debugPrint('SALVANDO PERFIL');
      debugPrint('USER ID: ${currentUser.id}');
      debugPrint('AUTH UID: ${supabase.auth.currentUser?.id}');
      debugPrint('USERNAME: $usernameLimpo');
      debugPrint('TEM FOTO: ${fotoBytes != null}');
      debugPrint('====================================');

      // ========================================================
      // 1. ATUALIZA USERNAME NO AUTH
      // ========================================================

      await supabase.auth.updateUser(
        UserAttributes(data: {'username': usernameLimpo}),
      );

      // ========================================================
      // 2. ENVIA FOTO
      // ========================================================

      String? novaFotoUrl = fotoUrl;

      if (fotoBytes != null) {
        novaFotoUrl = await profileService.uploadProfileImage(
          userId: currentUser.id,
          bytes: fotoBytes!,
        );
      }

      // ========================================================
      // 3. ATUALIZA STUDENTS
      // ========================================================

      await profileService.atualizarPerfil(
        userId: currentUser.id,
        username: usernameLimpo,
        fotoUrl: novaFotoUrl,
      );

      // ========================================================
      // 4. ATUALIZA ESTADO
      // ========================================================

      username = usernameLimpo;
      fotoUrl = novaFotoUrl;

      fotoSelecionada = null;
      fotoBytes = null;

      editandoUsername = false;

      debugPrint('====================================');
      debugPrint('PERFIL SALVO COM SUCESSO');
      debugPrint('====================================');
    } catch (e) {
      debugPrint('====================================');
      debugPrint('ERRO AO SALVAR PERFIL');
      debugPrint('$e');
      debugPrint('====================================');

      rethrow;
    } finally {
      salvando = false;
      notifyListeners();
    }
  }

  // ============================================================
  // SAIR DA CONTA
  // ============================================================

  Future<void> sairDaConta() async {
    try {
      await supabase.auth.signOut();

      debugPrint('====================================');
      debugPrint('USUÁRIO DESLOGADO');
      debugPrint('====================================');
    } catch (e) {
      debugPrint('====================================');
      debugPrint('ERRO AO SAIR DA CONTA');
      debugPrint('$e');
      debugPrint('====================================');

      rethrow;
    }
  }

  // ============================================================
  // LIMPAR FOTO SELECIONADA
  // ============================================================

  void limparFotoSelecionada() {
    fotoSelecionada = null;
    fotoBytes = null;
    notifyListeners();
  }
}
