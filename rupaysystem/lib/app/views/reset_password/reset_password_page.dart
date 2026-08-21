import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/theme/app_colors.dart';
import '../login/login_page.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final senhaController = TextEditingController();
  final confirmarSenhaController = TextEditingController();

  bool obscureSenha = true;
  bool obscureConfirmar = true;

  bool carregando = false;

  @override
  void initState() {
    super.initState();
    _inicializarRecuperacao();
  }

  Future<void> _inicializarRecuperacao() async {
    final uri = Uri.base;

    final code = uri.queryParameters['code'];

    if (code == null) {
      return;
    }

    try {
      await Supabase.instance.client.auth.exchangeCodeForSession(code);

      debugPrint("Sessão de recuperação criada.");
    } catch (e) {
      debugPrint("Erro ao trocar código por sessão: $e");
    }
  }

  @override
  void dispose() {
    senhaController.dispose();
    confirmarSenhaController.dispose();
    super.dispose();
  }

  Future<void> alterarSenha() async {
    if (senhaController.text.isEmpty || confirmarSenhaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Preencha todos os campos.")),
      );
      return;
    }

    if (senhaController.text != confirmarSenhaController.text) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("As senhas não coincidem.")));
      return;
    }

    if (senhaController.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("A senha deve possuir pelo menos 6 caracteres."),
        ),
      );
      return;
    }

    setState(() {
      carregando = true;
    });

    try {
      await Supabase.instance.client.auth.updateUser(
        UserAttributes(password: senhaController.text),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Senha alterada com sucesso!")),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
        (route) => false,
      );
    } on AuthException catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message)));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Erro: $e")));
    }

    if (mounted) {
      setState(() {
        carregando = false;
      });
    }
  }

  InputDecoration decoration({
    required String label,
    required bool obscure,
    required VoidCallback onPressed,
  }) {
    return InputDecoration(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      prefixIcon: const Icon(Icons.lock_outline),
      suffixIcon: IconButton(
        icon: Icon(
          obscure ? Icons.visibility_off : Icons.visibility,
          color: AppColors.primary,
        ),
        onPressed: onPressed,
      ),
      hintText: label,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.primary),
        title: Image.asset("lib/app/assets/img/Imagem2.png", width: 190),
      ),

      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),

            child: SizedBox(
              width: 420,

              child: Container(
                padding: const EdgeInsets.all(20),

                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.primary, width: 2),
                  borderRadius: BorderRadius.circular(15),
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    const Text(
                      "Redefinir Senha",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      "Digite sua nova senha.",
                      style: TextStyle(fontSize: 15),
                    ),

                    const SizedBox(height: 30),

                    const Text(
                      "Nova senha",
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    TextField(
                      controller: senhaController,
                      obscureText: obscureSenha,
                      decoration: decoration(
                        label: "Digite sua nova senha",
                        obscure: obscureSenha,
                        onPressed: () {
                          setState(() {
                            obscureSenha = !obscureSenha;
                          });
                        },
                      ),
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      "Confirmar senha",
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    TextField(
                      controller: confirmarSenhaController,
                      obscureText: obscureConfirmar,
                      decoration: decoration(
                        label: "Confirme sua senha",
                        obscure: obscureConfirmar,
                        onPressed: () {
                          setState(() {
                            obscureConfirmar = !obscureConfirmar;
                          });
                        },
                      ),
                    ),

                    const SizedBox(height: 35),

                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: carregando ? null : alterarSenha,
                        child: carregando
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                "Salvar nova senha",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                ),
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
