class PaymentModel {
  final String? id;
  final String studentId;
  final String mealId;
  final String paymentMethod;
  final String status;
  final double amount;
  final String? pixCode;

  /// ID do pagamento no Mercado Pago
  final String? mercadoPagoId;

  final DateTime? paidAt;
  final DateTime? createdAt;

  PaymentModel({
    this.id,
    required this.studentId,
    required this.mealId,
    required this.paymentMethod,
    required this.status,
    required this.amount,
    this.pixCode,
    this.mercadoPagoId,
    this.paidAt,
    this.createdAt,
  });

  factory PaymentModel.fromMap(Map<String, dynamic> map) {
    return PaymentModel(
      id: map['id'],
      studentId: map['student_id'],
      mealId: map['meal_id'],
      paymentMethod: map['payment_method'],
      status: map['status'],
      amount: (map['amount'] as num).toDouble(),
      pixCode: map['pix_code'],
      mercadoPagoId: map['mercado_pago_id'],
      paidAt: map['paid_at'] != null ? DateTime.parse(map['paid_at']) : null,
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'student_id': studentId,
      'meal_id': mealId,
      'payment_method': paymentMethod,
      'status': status,
      'amount': amount,
      'pix_code': pixCode,
      'mercado_pago_id': mercadoPagoId,
    };
  }

  PaymentModel copyWith({
    String? id,
    String? studentId,
    String? mealId,
    String? paymentMethod,
    String? status,
    double? amount,
    String? pixCode,
    String? mercadoPagoId,
    DateTime? paidAt,
    DateTime? createdAt,
  }) {
    return PaymentModel(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      mealId: mealId ?? this.mealId,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      status: status ?? this.status,
      amount: amount ?? this.amount,
      pixCode: pixCode ?? this.pixCode,
      mercadoPagoId: mercadoPagoId ?? this.mercadoPagoId,
      paidAt: paidAt ?? this.paidAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
