import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../core/theme/app_colors.dart';
import '../../models/payment_model.dart';
import '../../services/payment_service.dart';
import '../ticket/ticket_page.dart';

class PixDialog extends StatefulWidget {
  final PaymentModel pagamento;
  final String codigoPix;
  final double valor;

  const PixDialog({
    super.key,
    required this.pagamento,
    required this.codigoPix,
    required this.valor,
  });

  @override
  State<PixDialog> createState() => _PixDialogState();
}

class _PixDialogState extends State<PixDialog> {
  final PaymentService paymentService = PaymentService();

  StreamSubscription? _subscription;

  bool _cancelando = false;

  @override
  void initState() {
    super.initState();

    _subscription = paymentService.listenPayment(widget.pagamento.id!).listen((
      payment,
    ) {
      if (!mounted) return;

      debugPrint("Pagamento atualizado: $payment");

      if (payment["status"] == "pago") {
        // Fecha o diálogo
        Navigator.pop(context);

        // Vai para o ticket
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => TicketPage(paymentId: widget.pagamento.id!),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  Future<void> _fecharPagamento() async {
    if (_cancelando) return;

    setState(() {
      _cancelando = true;
    });

    try {
      await paymentService.cancelarPagamento(widget.pagamento.id!);

      if (!mounted) return;

      Navigator.pop(context);
    } catch (e) {
      debugPrint("Erro ao cancelar pagamento: $e");

      if (!mounted) return;

      setState(() {
        _cancelando = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Não foi possível cancelar o pagamento.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: AppColors.background,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset("lib/app/assets/img/Imagem2.png", width: 170),

              const SizedBox(height: 15),

              const Text(
                "Pagamento via Pix",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),

              const SizedBox(height: 15),

              Text(
                "Valor: R\$ ${widget.valor.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              QrImageView(data: widget.codigoPix, size: 220),

              const SizedBox(height: 20),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.primary, width: 1),
                ),
                child: SelectableText(
                  widget.codigoPix,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 11),
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.copy),
                  label: const Text("Copiar código Pix"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(50),
                  ),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: widget.codigoPix));

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Código Pix copiado.")),
                    );
                  },
                ),
              ),

              const SizedBox(height: 10),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: _cancelando ? null : _fecharPagamento,
                  style: OutlinedButton.styleFrom(
                    backgroundColor: AppColors.background,
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  child: _cancelando
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text("Fechar"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
