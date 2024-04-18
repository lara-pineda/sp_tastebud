import 'package:sp_tastebud/features/ingredients/data/ingredients_services.dart';

class IngredientsRepository {
  final IngredientsService _ingredientsService;

  IngredientsRepository(this._ingredientsService);

  Future<Map<String, dynamic>?> fetchIngredients(String userId) async {
    return await _ingredientsService.getIngredients(userId);
  }

  Future<void> saveIngredients(String userId, List<String> pantryEssentials,
      List<String> meat, List<String> vegetables) async {
    print("UserID 2:");
    print(userId);
    await _ingredientsService.updatePantryEssentials(userId, pantryEssentials);
    await _ingredientsService.updateMeat(userId, meat);
    await _ingredientsService.updateVegetables(userId, vegetables);
  }
}
