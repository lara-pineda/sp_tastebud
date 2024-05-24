import 'package:TasteBud/features/ingredients/data/ingredients_services.dart';

class IngredientsRepository {
  final IngredientsService _ingredientsService;

  IngredientsRepository(this._ingredientsService);

  Future<Map<String, dynamic>?> fetchIngredients(String userId) async {
    return await _ingredientsService.getIngredients(userId);
  }

  Future<void> saveIngredients(
      String userId,
      List<String> pantryEssentials,
      List<String> meat,
      List<String> vegetablesAndGreens,
      List<String> fishAndPoultry,
      List<String> baking) async {
    try {
      await _ingredientsService.updatePantryEssentials(
          userId, pantryEssentials);
      await _ingredientsService.updateMeat(userId, meat);
      await _ingredientsService.updateVegetablesAndGreens(
          userId, vegetablesAndGreens);
      await _ingredientsService.updateFishAndPoultry(userId, fishAndPoultry);
      await _ingredientsService.updateBaking(userId, baking);
    } catch (e) {
      throw Exception(e);
    }
  }
}
