import 'package:supabase_flutter/supabase_flutter.dart';

class MercadoPagoService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<Map<String, dynamic>> criarPagamento({
    required String paymentId,
    required double amount,
    required String description,
    required String payerEmail,
  }) async {
    final response = await _supabase.functions.invoke(
      'create-payment',
      body: {
        'payment_id': paymentId,
        'amount': amount,
        'description': description,
        'payer_email': payerEmail,
      },
    );

    if (response.status != 200 && response.status != 201) {
      throw Exception(
        response.data?['message'] ??
            response.data?['error'] ??
            'Erro ao criar pagamento no Mercado Pago.',
      );
    }

    return Map<String, dynamic>.from(response.data);
  }
}
