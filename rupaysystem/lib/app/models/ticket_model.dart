class TicketModel {
  final String id;
  final String studentId;
  final String mealId;
  final String status;
  final double amount;
  final bool used;
  final DateTime createdAt;
  final DateTime? paidAt;
  final DateTime? usedAt;

  const TicketModel({
    required this.id,
    required this.studentId,
    required this.mealId,
    required this.status,
    required this.amount,
    required this.used,
    required this.createdAt,
    this.paidAt,
    this.usedAt,
  });

  factory TicketModel.fromMap(Map<String, dynamic> map) {
    return TicketModel(
      id: map["id"],
      studentId: map["student_id"],
      mealId: map["meal_id"],
      status: map["status"],
      amount: (map["amount"] as num).toDouble(),
      used: map["used"] ?? false,
      createdAt: DateTime.parse(map["created_at"]),
      paidAt: map["paid_at"] != null ? DateTime.parse(map["paid_at"]) : null,
      usedAt: map["used_at"] != null ? DateTime.parse(map["used_at"]) : null,
    );
  }
}
