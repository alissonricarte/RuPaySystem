import 'package:flutter/material.dart';
import 'package:ru_pay_system/app/services/auth_service.dart';
import '../forgot_password/forgot_password_page.dart';
import '../../core/theme/app_colors.dart';
import '../meal/meal_page.dart';
import '../register/register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool obscurePassword = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

                  Transform.translate(
                    offset: const Offset(0, -30),

                    child: Container(
                      padding: const EdgeInsets.all(18),

                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.primary, width: 2),
                        borderRadius: BorderRadius.circular(15),
                      ),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          const Text(
                            "Login",
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),

                          const SizedBox(height: 4),

                          const Text(
                            "Utilize seu e-mail institucional",
                            style: TextStyle(fontSize: 15),
                          ),

                          const SizedBox(height: 25),

                          const Text(
                            "E-mail institucional",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: AppColors.primary,
                            ),
                          ),

                          const SizedBox(height: 8),

                          TextField(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,

                            decoration: InputDecoration(
                              hintText: "seuemail@alunos.ufersa.edu.br",

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
                            obscureText: obscurePassword,

                            decoration: InputDecoration(
                              prefixIcon: Padding(
                                padding: const EdgeInsets.all(10),

                                child: Image.asset(
                                  "lib/app/assets/icons/lock.png",
                                  width: 18,
                                  height: 18,
                                ),
                              ),

                              suffixIcon: IconButton(
                                icon: Icon(
                                  obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: AppColors.primary,
                                ),

                                onPressed: () {
                                  setState(() {
                                    obscurePassword = !obscurePassword;
                                  });
                                },
                              ),

                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),

                          const SizedBox(height: 8),

                          Align(
                            alignment: Alignment.centerRight,

                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const ForgotPasswordPage(),
                                  ),
                                );
                              },

                              child: const Text(
                                "Esqueceu a senha?",
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 10),

                          SizedBox(
                            width: double.infinity,
                            height: 50,

                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                  color: AppColors.primary,
                                  width: 2,
                                ),

                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),

                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const RegisterPage(),
                                  ),
                                );
                              },

                              child: const Text(
                                "Criar conta",
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 15),

                          SizedBox(
                            width: double.infinity,
                            height: 50,

                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,

                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),

                              onPressed: () async {
                                final sucesso = await AuthService().login(
                                  email: emailController.text.trim(),
                                  password: passwordController.text,
                                );

                                if (!mounted) return;

                                if (sucesso) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const MealPage(),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "E-mail ou senha inválidos.",
                                      ),
                                    ),
                                  );
                                }
                              },

                              child: const Text(
                                "Entrar",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
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
    );
  }
}
