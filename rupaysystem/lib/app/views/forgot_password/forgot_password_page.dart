import 'dart:async';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/theme/app_colors.dart';
import '../../services/auth_service.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  static const int _intervaloReenvio = 60; // o Supabase limita ~1 envio/min

  final emailController = TextEditingController();

  bool carregando = false;
  bool enviado = false;
  int segundosRestantes = 0;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    emailController.dispose();
    super.dispose();
  }

  void _iniciarContagem() {
    _timer?.cancel();
    setState(() => segundosRestantes = _intervaloReenvio);

    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      if (segundosRestantes <= 1) {
        t.cancel();
        setState(() => segundosRestantes = 0);
      } else {
        setState(() => segundosRestantes--);
      }
    });
  }

  void _mensagem(String texto) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(texto)));
  }

  Future<void> enviarLink() async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      _mensagem("Informe o e-mail da sua conta.");
      return;
    }

    final emailValido = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email);
    if (!emailValido) {
      _mensagem("Informe um e-mail válido.");
      return;
    }

    setState(() => carregando = true);

    try {
      await AuthService().recuperarSenha(email);

      if (!mounted) return;

      setState(() => enviado = true);
      _iniciarContagem();
    } on AuthException catch (e) {
      if (!mounted) return;

      final limite =
          e.code == 'over_email_send_rate_limit' || e.statusCode == '429';

      _mensagem(
        limite
            ? "Muitas tentativas. Aguarde um minuto e tente novamente."
            : "Não foi possível enviar o e-mail. Tente novamente.",
      );
    } catch (_) {
      if (!mounted) return;
      _mensagem("Não foi possível enviar o e-mail. Verifique sua conexão.");
    } finally {
      if (mounted) setState(() => carregando = false);
    }
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
                child: enviado
                    ? _construirConfirmacao()
                    : _construirFormulario(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _construirFormulario() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Esqueceu a senha?",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          "Informe o e-mail vinculado à sua conta e enviaremos um link para "
          "você criar uma nova senha.",
          style: TextStyle(fontSize: 15),
        ),
        const SizedBox(height: 30),
        const Text(
          "E-mail",
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          autofillHints: const [AutofillHints.email],
          onSubmitted: (_) => carregando ? null : enviarLink(),
          decoration: InputDecoration(
            hintText: "seuemail@alunos.ufersa.edu.br",
            prefixIcon: const Icon(Icons.mail_outline),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
        const SizedBox(height: 30),
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
            onPressed: carregando ? null : enviarLink,
            child: carregando
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3,
                    ),
                  )
                : const Text(
                    "Enviar link",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 12),
        Center(
          child: TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Voltar para o login",
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _construirConfirmacao() {
    final podeReenviar = segundosRestantes == 0 && !carregando;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(
          Icons.mark_email_read_outlined,
          size: 56,
          color: AppColors.primary,
        ),
        const SizedBox(height: 16),
        const Text(
          "Verifique seu e-mail",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Se ${emailController.text.trim()} estiver cadastrado, você receberá "
          "um link para redefinir a senha. Confira também a caixa de spam.",
          style: const TextStyle(fontSize: 15),
        ),
        const SizedBox(height: 30),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.primary, width: 2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: podeReenviar ? enviarLink : null,
            child: Text(
              podeReenviar
                  ? "Reenviar link"
                  : "Reenviar em ${segundosRestantes}s",
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Center(
          child: TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Voltar para o login",
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
