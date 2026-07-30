import 'auth_service.dart';

class MockAuthService implements AuthService {
  @override
  Future<bool> login({
    required String username,
    required String password,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    // Usuário temporário para desenvolvimento
    if (username == 'aluno' && password == '123456') {
      return true;
    }

    return false;
  }

  @override
  Future<void> logout() async {}
}
