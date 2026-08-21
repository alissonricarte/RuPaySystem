import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../models/student_model.dart';
import '../../services/auth_service.dart';

import '../../core/theme/app_colors.dart';
import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final nomeController = TextEditingController();
  final usuarioController = TextEditingController();
  final matriculaController = TextEditingController();
  final emailController = TextEditingController();
  final senhaController = TextEditingController();
  final confirmarSenhaController = TextEditingController();

  Uint8List? fotoSelecionada;

  bool obscureSenha = true;
  bool obscureConfirmar = true;

  String? campusSelecionado;
  String? cursoSelecionado;

  Future<void> selecionarFoto() async {
    try {
      final picker = ImagePicker();

      final XFile? imagem = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 800,
        maxHeight: 800,
      );

      if (imagem == null) return;

      final bytes = await imagem.readAsBytes();

      if (!mounted) return;

      setState(() {
        fotoSelecionada = bytes;
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao selecionar foto: $e')));
    }
  }

  final List<String> campus = [
    "Mossoró",
    "Angicos",
    "Caraúbas",
    "Pau dos Ferros",
  ];

  final Map<String, List<String>> cursos = {
    "Mossoró": [
      "Administração",
      "Agronomia",
      "Biotecnologia",
      "Ciência da Computação",
      "Ciência e Tecnologia",
      "Ciências Contábeis",
      "Direito",
      "Ecologia",
      "Engenharia Agrícola e Ambiental",
      "Engenharia Civil",
      "Engenharia Elétrica",
      "Engenharia Florestal",
      "Engenharia Mecânica",
      "Engenharia Química",
      "Engenharia de Pesca",
      "Engenharia de Petróleo",
      "Engenharia de Produção",
      "LEDOC",
      "Medicina",
      "Medicina Veterinária",
      "Psicologia",
      "Zootecnia",
    ],
    "Angicos": [
      "Ciência e Tecnologia",
      "Departamento de Ciências Exatas e Tecnologia da Informação",
      "Engenharia Civil",
      "Engenharia de Produção",
      "Gestão Ambiental",
      "Licenciatura em Computação e Informática",
      "Pedagogia",
      "Sistemas de Informação",
    ],
    "Caraúbas": [
      "Ciência e Tecnologia",
      "Engenharia Civil",
      "Engenharia Elétrica",
      "Engenharia Mecânica",
      "Letras - Inglês",
      "Letras - Libras",
      "Letras Português",
      "Licenciatura em Física",
      "Pedagogia Bilíngue: Libras/Língua Portuguesa",
    ],
    "Pau dos Ferros": [
      "Arquitetura e Urbanismo",
      "Bacharelado Interdisciplinar em Ciência e Tecnologia",
      "Engenharia Ambiental e Sanitária",
      "Engenharia Civil",
      "Engenharia de Computação",
      "Engenharia de Software",
      "Tecnologia da Informação",
    ],
  };
  @override
  void dispose() {
    nomeController.dispose();
    usuarioController.dispose();
    matriculaController.dispose();
    emailController.dispose();
    senhaController.dispose();
    confirmarSenhaController.dispose();
    super.dispose();
  }

  InputDecoration decoration(String hint, String icon) {
    return InputDecoration(
      hintText: hint,

      prefixIcon: Padding(
        padding: const EdgeInsets.all(10),
        child: Image.asset(icon, width: 18, height: 18),
      ),

      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.grey),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),

      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
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
                      "Criar Conta",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),

                    const SizedBox(height: 5),

                    const Text(
                      "Cadastre sua conta institucional",
                      style: TextStyle(fontSize: 15),
                    ),

                    const SizedBox(height: 25),
                    Center(
                      child: Stack(
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
                              child: fotoSelecionada != null
                                  ? Image.memory(
                                      fotoSelecionada!,
                                      width: 140,
                                      height: 140,
                                      fit: BoxFit.cover,
                                    )
                                  : const Icon(
                                      Icons.person,
                                      size: 75,
                                      color: AppColors.primary,
                                    ),
                            ),
                          ),

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
                              onPressed: selecionarFoto,
                              icon: const Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 21,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      "Nome completo",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),

                    const SizedBox(height: 8),

                    TextField(
                      controller: nomeController,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'[a-zA-ZÀ-ÿ\s]'),
                        ),
                      ],
                      decoration: decoration(
                        "Digite seu nome",
                        "lib/app/assets/icons/user.png",
                      ),
                    ),
                    const SizedBox(height: 18),

                    const Text(
                      "Usuário",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),

                    const SizedBox(height: 8),

                    TextField(
                      controller: usuarioController,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
                      ],
                      decoration: decoration(
                        "Digite seu usuário",
                        "lib/app/assets/icons/user.png",
                      ),
                    ),
                    const SizedBox(height: 18),

                    const Text(
                      "Matrícula",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),

                    const SizedBox(height: 8),

                    TextField(
                      controller: matriculaController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: decoration(
                        "Digite sua matrícula",
                        "lib/app/assets/icons/user.png",
                      ),
                    ),

                    const SizedBox(height: 18),

                    const Text(
                      "E-mail institucional",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),

                    const SizedBox(height: 8),

                    TextField(
                      controller: emailController,
                      decoration: decoration(
                        "usuario@alunos.ufersa.edu.br",
                        "lib/app/assets/icons/user.png",
                      ),
                    ),

                    const SizedBox(height: 18),

                    const Text(
                      "Campus",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),

                    const SizedBox(height: 8),

                    DropdownButtonFormField<String>(
                      value: campusSelecionado,
                      isExpanded: true,
                      dropdownColor: Colors.white,

                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: AppColors.primary,
                            width: 2,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 16,
                        ),
                      ),

                      hint: const Text("Selecione o campus"),

                      items: campus.map((campus) {
                        return DropdownMenuItem<String>(
                          value: campus,
                          child: Text(
                            campus,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: AppColors.primary),
                          ),
                        );
                      }).toList(),

                      onChanged: (value) {
                        setState(() {
                          campusSelecionado = value;
                          cursoSelecionado = null;
                        });
                      },
                    ),

                    const SizedBox(height: 18),

                    const Text(
                      "Curso",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),

                    const SizedBox(height: 8),

                    DropdownButtonFormField<String>(
                      value: cursoSelecionado,
                      isExpanded: true,
                      dropdownColor: Colors.white,

                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: AppColors.primary,
                            width: 2,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 16,
                        ),
                      ),

                      hint: const Text("Selecione o curso"),

                      items:
                          (campusSelecionado == null
                                  ? <String>[]
                                  : cursos[campusSelecionado]!)
                              .map(
                                (curso) => DropdownMenuItem<String>(
                                  value: curso,
                                  child: Text(
                                    curso,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),

                      onChanged: (value) {
                        setState(() {
                          cursoSelecionado = value;
                        });
                      },
                    ),

                    const SizedBox(height: 18),

                    const Text(
                      "Senha",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),

                    const SizedBox(height: 8),

                    TextField(
                      controller: senhaController,
                      obscureText: obscureSenha,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Image.asset(
                            "lib/app/assets/icons/lock.png",
                            width: 16,
                            height: 16,
                          ),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscureSenha
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              obscureSenha = !obscureSenha;
                            });
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    const Text(
                      "Confirmar senha",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),

                    const SizedBox(height: 8),

                    TextField(
                      controller: confirmarSenhaController,
                      obscureText: obscureConfirmar,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Image.asset(
                            "lib/app/assets/icons/lock.png",
                            width: 16,
                            height: 16,
                          ),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscureConfirmar
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              obscureConfirmar = !obscureConfirmar;
                            });
                          },
                        ),
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
                        onPressed: () async {
                          if (campusSelecionado == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Selecione um campus."),
                              ),
                            );
                            return;
                          }

                          if (cursoSelecionado == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Selecione um curso."),
                              ),
                            );
                            return;
                          }

                          if (!emailController.text
                              .trim()
                              .toLowerCase()
                              .endsWith("@alunos.ufersa.edu.br")) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Utilize um e-mail institucional da UFERSA.",
                                ),
                              ),
                            );
                            return;
                          }

                          if (senhaController.text !=
                              confirmarSenhaController.text) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("As senhas não coincidem."),
                              ),
                            );
                            return;
                          }

                          try {
                            final student = StudentModel(
                              fullName: nomeController.text.trim(),
                              username: usuarioController.text.trim(),
                              registration: matriculaController.text.trim(),
                              email: emailController.text.trim().toLowerCase(),
                              campus: campusSelecionado!,
                              course: cursoSelecionado!,
                            );

                            await AuthService().cadastrar(
                              student,
                              senhaController.text,
                            );

                            if (!mounted) return;

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Conta criada! Verifique seu e-mail para confirmar sua conta.",
                                ),
                              ),
                            );

                            Navigator.pop(context);
                          } catch (e) {
                            if (!mounted) return;

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Erro ao cadastrar: $e")),
                            );
                          }
                        },
                        child: const Text(
                          "Criar Conta",
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
          ),
        ),
      ),
    );
  }
}
