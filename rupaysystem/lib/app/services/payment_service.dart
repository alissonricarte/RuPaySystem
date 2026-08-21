import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/payment_model.dart';

class PaymentService {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Cria um pagamento
  Future<PaymentModel> createPayment(PaymentModel payment) async {
    final response = await _supabase
        .from('payments')
        .insert(payment.toMap())
        .select()
        .single();

    return PaymentModel.fromMap(response);
  }

  /// Cancela um pagamento pendente
  Future<void> cancelarPagamento(String paymentId) async {
    try {
      final response = await _supabase
          .from('payments')
          .update({'status': 'cancelado'})
          .eq('id', paymentId)
          .eq('status', 'pendente')
          .select();

      print('Pagamento cancelado: $response');

      if (response.isEmpty) {
        throw Exception(
          'O pagamento não foi cancelado. '
          'Ele pode não estar mais pendente.',
        );
      }
    } catch (e) {
      print('Erro ao cancelar pagamento: $e');
      rethrow;
    }
  }

  /// Lista todos os pagamentos
  Future<List<PaymentModel>> getPayments() async {
    final response = await _supabase
        .from('payments')
        .select()
        .order('created_at', ascending: false);

    return (response as List)
        .map((item) => PaymentModel.fromMap(item))
        .toList();
  }

  /// Atualiza pelo ID da tabela
  Future<void> updateStatus(String paymentId, String status) async {
    await _supabase
        .from('payments')
        .update({'status': status, 'paid_at': DateTime.now().toIso8601String()})
        .eq('id', paymentId);
  }

  /// Atualiza pelo ID do Mercado Pago
  Future<void> updateStatusByMercadoPagoId(
    String mercadoPagoId,
    String status,
  ) async {
    await _supabase
        .from('payments')
        .update({'status': status, 'paid_at': DateTime.now().toIso8601String()})
        .eq('mercado_pago_id', mercadoPagoId);
  }

  /// Busca pelo ID do Mercado Pago
  Future<PaymentModel?> getByMercadoPagoId(String mercadoPagoId) async {
    final response = await _supabase
        .from('payments')
        .select()
        .eq('mercado_pago_id', mercadoPagoId)
        .maybeSingle();

    if (response == null) {
      return null;
    }

    return PaymentModel.fromMap(response);
  }

  /// Escuta alterações de um pagamento
  Stream<Map<String, dynamic>> listenPayment(String paymentId) {
    return _supabase
        .from('payments')
        .stream(primaryKey: ['id'])
        .eq('id', paymentId)
        .map((event) => event.first);
  }

  /// Busca um pagamento pelo ID
  Future<PaymentModel?> getById(String paymentId) async {
    final response = await _supabase
        .from('payments')
        .select()
        .eq('id', paymentId)
        .maybeSingle();

    if (response == null) {
      return null;
    }

    return PaymentModel.fromMap(response);
  }
}
