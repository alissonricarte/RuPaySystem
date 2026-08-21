import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ru_pay_system/app/views/login/login_page.dart';

import '../../core/theme/app_colors.dart';
import '../../viewmodels/profile_view_model.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final TextEditingController usernameController;

  @override
  void initState() {
    super.initState();

    usernameController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final viewModel = context.read<ProfileViewModel>();

      viewModel.carregarPerfil();
    });
  }

  @override
  void dispose() {
    usernameController.dispose();
    super.dispose();
  }

  Future<void> salvarInformacoes() async {
    final username = usernameController.text.trim();

    if (username.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Digite um username.')));

      return;
    }

    final viewModel = context.read<ProfileViewModel>();

    try {
      await viewModel.salvarPerfil(username);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Informações salvas com sucesso!')),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao salvar informações: $e')));
    }
  }

  // ============================================================
  // SAIR DA CONTA
  // ============================================================

  Future<void> sairDaConta() async {
    final viewModel = context.read<ProfileViewModel>();

    try {
      await viewModel.sairDaConta();

      if (!mounted) return;

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginPage()),
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao sair da conta: $e')));
    }
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileViewModel>(
      builder: (context, viewModel, child) {
        final user = viewModel.user;

        if (user == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final metadata = user.userMetadata ?? {};

        final String nome =
            metadata['full_name']?.toString() ?? 'Não informado';

        final String matricula =
            metadata['registration']?.toString() ?? 'Não informado';

        final String curso = metadata['course']?.toString() ?? 'Não informado';

        final String campus = metadata['campus']?.toString() ?? 'Não informado';

        final String email = user.email ?? 'Não informado';

        // ======================================================
        // ATUALIZA CONTROLLER COM USERNAME DO VIEWMODEL
        // ======================================================

        if (!viewModel.editandoUsername &&
            usernameController.text != (viewModel.username ?? '')) {
          usernameController.text = viewModel.username ?? '';
        }

        return Scaffold(
          backgroundColor: Colors.white,

          // ====================================================
          // APP BAR
          // ====================================================
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,

            title: Image.asset(
              'lib/app/assets/img/Imagem2.png',
              height: 80,
              fit: BoxFit.contain,
            ),

            automaticallyImplyLeading: false,

            actions: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.close,
                  color: AppColors.primary,
                  size: 30,
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),

          // ====================================================
          // BODY
          // ====================================================
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),

              child: Column(
                children: [
                  // ==================================================
                  // FOTO DO ALUNO
                  // ==================================================
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        width: 140,
                        height: 140,

                        decoration: BoxDecoration(
                          shape: BoxShape.circle,

                          border: Border.all(
                            color: AppColors.primary,
                            width: 3,
                          ),
                        ),

                        child: ClipOval(
                          child: viewModel.fotoBytes != null
                              ? Image.memory(
                                  viewModel.fotoBytes!,
                                  width: 140,
                                  height: 140,
                                  fit: BoxFit.cover,
                                )
                              : viewModel.fotoUrl != null &&
                                    viewModel.fotoUrl!.isNotEmpty
                              ? Image.network(
                                  viewModel.fotoUrl!,
                                  width: 140,
                                  height: 140,
                                  fit: BoxFit.cover,

                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(
                                      Icons.person,
                                      size: 75,
                                      color: AppColors.primary,
                                    );
                                  },
                                )
                              : const Icon(
                                  Icons.person,
                                  size: 75,
                                  color: AppColors.primary,
                                ),
                        ),
                      ),

                      // ==================================================
                      // BOTÃO DA CÂMERA
                      // ==================================================
                      Container(
                        width: 42,
                        height: 42,

                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,

                          border: Border.all(color: Colors.white, width: 3),
                        ),

                        child: IconButton(
                          padding: EdgeInsets.zero,

                          onPressed: viewModel.salvando
                              ? null
                              : () async {
                                  try {
                                    await viewModel.selecionarFoto();
                                  } catch (e) {
                                    if (!context.mounted) return;

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Erro ao selecionar foto: $e',
                                        ),
                                      ),
                                    );
                                  }
                                },

                          icon: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 21,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  // ==================================================
                  // NOME
                  // ==================================================
                  Text(
                    nome,
                    textAlign: TextAlign.center,

                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),

                  const SizedBox(height: 30),

                  // ==================================================
                  // INFORMAÇÕES
                  // ==================================================
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),

                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.primary, width: 1.5),

                      borderRadius: BorderRadius.circular(12),
                    ),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        // ==========================================
                        // USERNAME
                        // ==========================================
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,

                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,

                                children: [
                                  const Text(
                                    'Username',

                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(height: 6),

                                  if (viewModel.editandoUsername)
                                    TextField(
                                      controller: usernameController,
                                      autofocus: true,

                                      decoration: InputDecoration(
                                        hintText: 'Digite seu username',

                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),

                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),

                                          borderSide: const BorderSide(
                                            color: AppColors.primary,
                                            width: 2,
                                          ),
                                        ),
                                      ),
                                    )
                                  else
                                    Text(
                                      viewModel.username == null ||
                                              viewModel.username!.isEmpty
                                          ? 'Não informado'
                                          : viewModel.username!,

                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                      ),
                                    ),
                                ],
                              ),
                            ),

                            const SizedBox(width: 10),

                            // ========================================
                            // LÁPIS
                            // ========================================
                            IconButton(
                              onPressed: viewModel.salvando
                                  ? null
                                  : () {
                                      viewModel.iniciarEdicaoUsername();
                                    },

                              icon: const Icon(
                                Icons.edit,
                                color: AppColors.primary,
                                size: 25,
                              ),

                              tooltip: 'Editar username',
                            ),
                          ],
                        ),

                        _divider(),

                        _info('Nome', nome),

                        _divider(),

                        _info('Matrícula', matricula),

                        _divider(),

                        _info('E-mail', email),

                        _divider(),

                        _info('Curso', curso),

                        _divider(),

                        _info('Campus', campus),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // ==================================================
                  // SALVAR INFORMAÇÕES
                  // ==================================================
                  SizedBox(
                    width: double.infinity,
                    height: 50,

                    child: ElevatedButton.icon(
                      onPressed: viewModel.salvando ? null : salvarInformacoes,

                      icon: viewModel.salvando
                          ? const SizedBox(
                              width: 20,
                              height: 20,

                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.save),

                      label: Text(
                        viewModel.salvando
                            ? 'Salvando...'
                            : 'Salvar informações',
                      ),

                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ==================================================
                  // SAIR DA CONTA
                  // ==================================================
                  SizedBox(
                    width: double.infinity,
                    height: 50,

                    child: ElevatedButton.icon(
                      onPressed: viewModel.salvando ? null : sairDaConta,

                      icon: const Icon(Icons.logout),

                      label: const Text('Sair da conta'),

                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // INFORMAÇÃO
  // ============================================================

  Widget _info(String titulo, String valor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Text(
          titulo,

          style: const TextStyle(
            color: AppColors.primary,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 4),

        Text(valor, style: const TextStyle(color: Colors.black, fontSize: 16)),
      ],
    );
  }

  // ============================================================
  // DIVISOR
  // ============================================================

  Widget _divider() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 12),

      child: Divider(height: 1),
    );
  }
}
