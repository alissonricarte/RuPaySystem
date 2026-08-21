class MealModel {
  final String id;
  final String name;
  final double price;
  final String startTime;
  final String endTime;
  final bool active;

  MealModel({
    required this.id,
    required this.name,
    required this.price,
    required this.startTime,
    required this.endTime,
    required this.active,
  });

  factory MealModel.fromMap(Map<String, dynamic> map) {
    return MealModel(
      id: map['id'],
      name: map['name'],
      price: (map['price'] as num).toDouble(),
      startTime: map['start_time'],
      endTime: map['end_time'],
      active: map['active'],
    );
  }
}
