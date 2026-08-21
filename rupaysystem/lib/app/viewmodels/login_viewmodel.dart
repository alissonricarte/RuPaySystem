import 'package:flutter/foundation.dart';
import '../services/auth_service.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthService authService;

  LoginViewModel({required this.authService});

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  Future<bool> login({
    required String username,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;

    notifyListeners();

    try {
      final success = await authService.login(
        email: username,
        password: password,
      );

      if (!success) {
        _errorMessage = 'Usuário ou senha inválidos.';
      }

      return success;
    } catch (e) {
      _errorMessage = 'Não foi possível realizar o login.';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
