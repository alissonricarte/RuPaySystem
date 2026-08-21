import '../models/meal_model.dart';
import '../repositories/meal_repository.dart';

class MealService {
  final MealRepository _repository = MealRepository();

  Future<MealModel?> getMeal(String name) async {
    return await _repository.getMealByName(name);
  }

  Future<List<MealModel>> getMeals() async {
    return await _repository.getMeals();
  }
}
