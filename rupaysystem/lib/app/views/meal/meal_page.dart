import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class MealPage extends StatefulWidget {
  const MealPage({super.key});

  @override
  State<MealPage> createState() => _MealPageState();
}

class _MealPageState extends State<MealPage> {
  String? selectedMeal;
  String? selectedPayment;

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

              child: Container(
                padding: const EdgeInsets.fromLTRB(18, 25, 18, 30),

                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.primary, width: 2),
                  borderRadius: BorderRadius.circular(15),
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,

                  children: [
                    Center(
                      child: Image.asset(
                        "lib/app/assets/img/Imagem2.png",
                        width: 280,
                      ),
                    ),

                    const SizedBox(height: 25),

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
                      onChanged: (value) {
                        setState(() {
                          selectedPayment = value;
                        });
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
