import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymapp/features/fitness/nutrition/data/nutrition_model.dart';
import 'package:gymapp/features/fitness/nutrition/data/nutrition_service.dart';

final nutritionProvider =
    StateNotifierProvider<NutritionNotifier, AsyncValue<NutritionPlan?>>((ref) {
  return NutritionNotifier(NutritionService());
});

class NutritionNotifier extends StateNotifier<AsyncValue<NutritionPlan?>> {
  final NutritionService _nutritionService;

  NutritionNotifier(this._nutritionService)
      : super(const AsyncValue.loading()) {
    fetchNutritionPlan();
  }

  Future<void> fetchNutritionPlan() async {
    state = const AsyncValue.loading();
    try {
      final nutritionPlan = await _nutritionService.getNutritionPlan();
      state = AsyncValue.data(nutritionPlan);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> saveNutritionPlan(NutritionPlan nutritionPlan) async {
    state = const AsyncValue.loading();
    try {
      await _nutritionService.saveNutritionPlan(nutritionPlan);
      state = AsyncValue.data(nutritionPlan);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}
