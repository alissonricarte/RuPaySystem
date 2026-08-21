import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../core/theme/app_colors.dart';
import '../../services/ticket_service.dart';

class TicketPage extends StatefulWidget {
  final String paymentId;

  const TicketPage({super.key, required this.paymentId});

  @override
  State<TicketPage> createState() => _TicketPageState();
}

class _TicketPageState extends State<TicketPage> {
  final TicketService service = TicketService();

  Map<String, dynamic>? ticket;

  bool loading = true;

  @override
  void initState() {
    super.initState();
    carregarTicket();
  }

  Future<void> carregarTicket() async {
    final result = await service.getTicket(widget.paymentId);

    setState(() {
      ticket = result;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final aluno = ticket!["students"];
    final String? fotoUrl = aluno["profile_photo_url"]?.toString();
    final bool ativo = ticket!["status"] == "pago";

    final qrData = jsonEncode({
      "payment_id": ticket!["id"],
      "student_id": ticket!["student_id"],
      "used": ticket!["used"],
    });

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,

        title: Padding(
          padding: const EdgeInsets.only(top: 15), // desce a logo
          child: Image.asset(
            "lib/app/assets/img/Imagem2.png",
            height: 110,
            fit: BoxFit.contain,
          ),
        ),
      ),

      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 25),
            child: Column(
              children: [
                Container(
                  width: 280,
                  height: 280,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.primary, width: 2),
                  ),
                  child: QrImageView(data: qrData),
                ),

                const SizedBox(height: 35),

                Container(
                  width: 360,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.primary, width: 1.5),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                                children: [
                                  const TextSpan(
                                    text: "Nome: ",
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(text: aluno["full_name"]),
                                ],
                              ),
                            ),

                            const SizedBox(height: 8),

                            RichText(
                              text: TextSpan(
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                                children: [
                                  const TextSpan(
                                    text: "Matrícula: ",
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(text: aluno["registration"]),
                                ],
                              ),
                            ),

                            const SizedBox(height: 8),

                            RichText(
                              text: TextSpan(
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                                children: [
                                  const TextSpan(
                                    text: "Curso: ",
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(text: aluno["course"]),
                                ],
                              ),
                            ),

                            const SizedBox(height: 8),

                            RichText(
                              text: TextSpan(
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                                children: [
                                  const TextSpan(
                                    text: "Campus: ",
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(text: aluno["campus"]),
                                ],
                              ),
                            ),

                            const SizedBox(height: 12),

                            Row(
                              children: [
                                const Text(
                                  "Status: ",
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                Text(
                                  ativo ? "Ativo" : "Pendente",
                                  style: TextStyle(
                                    color: ativo ? Colors.green : Colors.orange,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(width: 6),

                                CircleAvatar(
                                  radius: 4,
                                  backgroundColor: ativo
                                      ? Colors.green
                                      : Colors.orange,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 15),

                      Container(
                        width: 95,
                        height: 95,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.primary,
                            width: 1.5,
                          ),
                        ),
                        child: fotoUrl != null && fotoUrl.isNotEmpty
                            ? Image.network(
                                fotoUrl,
                                width: 95,
                                height: 95,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(
                                    Icons.person,
                                    size: 70,
                                    color: AppColors.primary,
                                  );
                                },
                              )
                            : const Icon(
                                Icons.person,
                                size: 70,
                                color: AppColors.primary,
                              ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
