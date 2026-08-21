import 'dart:async';

import '../models/payment_model.dart';
import 'payment_service.dart';

class PaymentStatusService {
  final PaymentService _paymentService = PaymentService();

  Timer? _timer;

  /// Consulta o banco a cada 2 segundos.
  void start({
    required String paymentId,
    required Function(PaymentModel payment) onPaid,
  }) {
    stop();

    _timer = Timer.periodic(const Duration(seconds: 2), (timer) async {
      final payment = await _paymentService.getById(paymentId);

      if (payment == null) return;

      if (payment.status.toLowerCase() == "pago") {
        stop();

        onPaid(payment);
      }
    });
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }
}
