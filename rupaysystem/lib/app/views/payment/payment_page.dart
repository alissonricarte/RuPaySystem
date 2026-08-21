import 'package:flutter/material.dart';

class PaymentPage extends StatelessWidget {
  final String codigoPix;
  final double valor;

  const PaymentPage({super.key, required this.codigoPix, required this.valor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pagamento")),
      body: Center(
        child: Text(
          "Valor: R\$ ${valor.toStringAsFixed(2)}\n\n$codigoPix",
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
