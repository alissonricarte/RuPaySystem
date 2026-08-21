import 'package:flutter/material.dart';

import '../models/student_model.dart';
import '../services/auth_service.dart';

class RegisterViewModel extends ChangeNotifier {
  final AuthService authService;

  RegisterViewModel({required this.authService});

  bool isLoading = false;
  String? error;

  Future<bool> cadastrar(StudentModel student, String senha) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      await authService.cadastrar(student, senha);

      isLoading = false;
      notifyListeners();

      return true;
    } catch (e) {
      error = e.toString();

      isLoading = false;
      notifyListeners();

      return false;
    }
  }
}
