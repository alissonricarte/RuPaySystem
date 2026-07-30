import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../services/mock_auth_service.dart';
import '../../viewmodels/login_viewmodel.dart';
import '../meal/meal_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController userController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    userController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginViewModel(authService: MockAuthService()),

      child: Scaffold(
        backgroundColor: Colors.white,

        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),

              child: SizedBox(
                width: 380,

                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,

                  children: [
                    // LOGO
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),

                      child: Align(
                        alignment: Alignment.centerLeft,

                        child: Transform.translate(
                          offset: const Offset(-30, 20),

                          child: Image.asset(
                            "lib/app/assets/img/Imagem2.png",
                            width: 250,
                          ),
                        ),
                      ),
                    ),

                    // CAIXA DE LOGIN
                    Transform.translate(
                      offset: const Offset(0, -30),

                      child: Container(
                        padding: const EdgeInsets.all(18),

                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.primary,
                            width: 2,
                          ),

                          borderRadius: BorderRadius.circular(15),
                        ),

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            const Text(
                              "Entrar com SIGAA",

                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),

                            const SizedBox(height: 4),

                            const Text(
                              "Alunos e professores UFERSA",

                              style: TextStyle(fontSize: 15),
                            ),

                            const SizedBox(height: 25),

                            // USUÁRIO
                            const Text(
                              "Usuário",

                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: AppColors.primary,
                              ),
                            ),

                            const SizedBox(height: 8),

                            TextField(
                              controller: userController,

                              decoration: InputDecoration(
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.all(10),

                                  child: Image.asset(
                                    "lib/app/assets/icons/user.png",
                                    width: 18,
                                    height: 18,
                                  ),
                                ),

                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),

                            // SENHA
                            const Text(
                              "Senha",

                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: AppColors.primary,
                              ),
                            ),

                            const SizedBox(height: 8),

                            TextField(
                              controller: passwordController,

                              obscureText: true,

                              decoration: InputDecoration(
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.all(10),

                                  child: Image.asset(
                                    "lib/app/assets/icons/lock.png",
                                    width: 18,
                                    height: 18,
                                  ),
                                ),

                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),

                            const SizedBox(height: 30),

                            // BOTÃO
                            SizedBox(
                              width: double.infinity,
                              height: 50,

                              child: Consumer<LoginViewModel>(
                                builder: (context, viewModel, child) {
                                  return ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary,

                                      disabledBackgroundColor: AppColors.primary
                                          .withOpacity(0.7),

                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),

                                    onPressed: viewModel.isLoading
                                        ? null
                                        : () async {
                                            final success = await viewModel
                                                .login(
                                                  username: userController.text
                                                      .trim(),
                                                  password:
                                                      passwordController.text,
                                                );

                                            if (!mounted) return;

                                            if (success) {
                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (_) =>
                                                      const MealPage(),
                                                ),
                                              );
                                            } else {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    viewModel.errorMessage ??
                                                        'Usuário ou senha inválidos.',
                                                  ),
                                                ),
                                              );
                                            }
                                          },

                                    child: viewModel.isLoading
                                        ? const SizedBox(
                                            width: 24,
                                            height: 24,

                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,

                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                    Colors.white,
                                                  ),
                                            ),
                                          )
                                        : const Text(
                                            "Entrar com SIGAA",

                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
