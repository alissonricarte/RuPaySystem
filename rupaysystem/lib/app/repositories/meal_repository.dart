import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/meal_model.dart';

class MealRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<MealModel>> getMeals() async {
    final response = await _supabase.from('meals').select();

    return (response as List).map((e) => MealModel.fromMap(e)).toList();
  }

  Future<MealModel?> getMealByName(String name) async {
    debugPrint("Buscando no banco: $name");

    final response = await _supabase
        .from('meals')
        .select()
        .eq('name', name)
        .eq('active', true)
        .maybeSingle();

    debugPrint("Resposta do banco: $response");

    if (response == null) return null;

    return MealModel.fromMap(response);
  }
}
