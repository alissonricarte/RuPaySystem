import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ru_pay_system/app/viewmodels/profile_view_model.dart';
import 'package:ru_pay_system/app/views/profile/profile_page.dart';
import 'package:ru_pay_system/app/views/ticket/ticket_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/theme/app_colors.dart';
import '../../models/payment_model.dart';
import '../../services/meal_service.dart';
import '../../services/payment_service.dart';
import '../../services/mercado_pago_service.dart';
import '../payment/pix_dialog.dart';

class MealPage extends StatefulWidget {
  const MealPage({super.key});

  @override
  State<MealPage> createState() => _MealPageState();
}

class _MealPageState extends State<MealPage> {
  String? selectedMeal;
  String? selectedPayment;

  final MealService mealService = MealService();
  final PaymentService paymentService = PaymentService();
  final MercadoPagoService mercadoPagoService = MercadoPagoService();

  final supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    //\testarSupabase();
  }

  Future<void> testarSupabase() async {
    final meals = await mealService.getMeals();

    debugPrint("Quantidade: ${meals.length}");

    for (final meal in meals) {
      debugPrint("${meal.name} - ${meal.price}");
    }
  }

  Future<PaymentModel> criarPagamento() async {
    final mealName = selectedMeal == "almoco" ? "Almoço" : "Janta";

    final meal = await mealService.getMeal(mealName);

    if (meal == null) {
      throw Exception("Refeição '$mealName' não encontrada.");
    }

    final user = supabase.auth.currentUser;

    if (user == null) {
      throw Exception("Nenhum usuário logado.");
    }

    final pagamento = PaymentModel(
      studentId: user.id,
      mealId: meal.id,
      paymentMethod: selectedPayment!,
      status: "pendente",
      amount: meal.price,
    );

    return await paymentService.createPayment(pagamento);
  }

  Future<bool> _confirmarPagamento(String formaPagamento) async {
    final nomePagamento = formaPagamento == "pix" ? "Pix" : "Dinheiro";

    final nomeRefeicao = selectedMeal == "almoco" ? "Almoço" : "Janta";

    final resultado = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: const Text(
            "Confirmar pagamento",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          content: Text(
            "Você realmente deseja pagar a refeição "
            "$nomeRefeicao usando $nomePagamento?",
            style: const TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text(
                "Cancelar",
                style: TextStyle(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text("Confirmar"),
            ),
          ],
        );
      },
    );

    return resultado ?? false;
  }

  @override
  Widget build(BuildContext context) {
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

        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChangeNotifierProvider(
                    create: (_) => ProfileViewModel(),
                    child: const ProfilePage(),
                  ),
                ),
              );
            },
            icon: const Icon(
              Icons.account_circle_rounded,
              color: AppColors.primary,
              size: 34,
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: SizedBox(
              width: 380,
              child: Container(
                padding: const EdgeInsets.fromLTRB(18, 25, 18, 30),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.primary, width: 2),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      "Qual refeição:",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),

                    const SizedBox(height: 22),

                    RadioGroup<String>(
                      groupValue: selectedMeal,
                      onChanged: (value) {
                        setState(() {
                          selectedMeal = value;
                        });
                      },
                      child: Column(
                        children: [
                          _buildOption(title: "Almoço", value: "almoco"),
                          const SizedBox(height: 28),
                          _buildOption(title: "Janta", value: "janta"),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    const Text(
                      "Forma de pagamento:",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),

                    const SizedBox(height: 22),

                    RadioGroup<String>(
                      groupValue: selectedPayment,
                      onChanged: (value) async {
                        if (value == null) return;

                        if (selectedMeal == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Selecione a refeição primeiro."),
                            ),
                          );
                          return;
                        }

                        // Pergunta antes de criar o pagamento
                        final confirmou = await _confirmarPagamento(value);

                        if (!confirmou) {
                          return;
                        }

                        // Só define a forma de pagamento depois da confirmação
                        setState(() {
                          selectedPayment = value;
                        });

                        try {
                          // Agora sim salva o pagamento na tabela payments
                          final pagamento = await criarPagamento();

                          // Cria o pagamento no Mercado Pago
                          final mp = await mercadoPagoService.criarPagamento(
                            paymentId: pagamento.id!,
                            amount: pagamento.amount,
                            description: "Pagamento RU",
                            payerEmail: supabase.auth.currentUser!.email!,
                          );

                          debugPrint("=================================");
                          debugPrint("Resposta Mercado Pago:");
                          debugPrint(mp.toString());

                          debugPrint("point_of_interaction:");
                          debugPrint(mp["point_of_interaction"].toString());

                          debugPrint("transaction_data:");
                          debugPrint(
                            mp["point_of_interaction"]?["transaction_data"]
                                .toString(),
                          );

                          debugPrint("=================================");

                          if (!mounted) return;

                          if (value == "pix") {
                            final pointOfInteraction =
                                mp["point_of_interaction"];

                            if (pointOfInteraction == null ||
                                pointOfInteraction["transaction_data"] ==
                                    null) {
                              throw Exception(
                                mp["message"] ??
                                    mp["error"] ??
                                    "O Mercado Pago não retornou os dados do PIX.",
                              );
                            }

                            final qrCode =
                                pointOfInteraction["transaction_data"]["qr_code"]
                                    as String;

                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (_) => PixDialog(
                                pagamento: pagamento,
                                codigoPix: qrCode,
                                valor: pagamento.amount,
                              ),
                            );
                          } else {
                            if (!mounted) return;

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    TicketPage(paymentId: pagamento.id!),
                              ),
                            );
                          }
                        } catch (e, s) {
                          debugPrint("ERRO:");
                          debugPrint(e.toString());
                          debugPrint(s.toString());

                          if (!mounted) return;

                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text(e.toString())));
                        }
                      },
                      child: Column(
                        children: [
                          _buildOption(title: "Pix", value: "pix"),
                          const SizedBox(height: 28),
                          _buildOption(title: "Dinheiro", value: "dinheiro"),
                        ],
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

  Widget _buildOption({required String title, required String value}) {
    return Container(
      width: double.infinity,
      height: 45,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primary, width: 2),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
          Radio<String>(
            value: value,
            activeColor: AppColors.primary,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: VisualDensity.compact,
          ),
        ],
      ),
    );
  }
}
