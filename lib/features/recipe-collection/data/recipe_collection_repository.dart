import 'recipe_collection_services.dart';

class RecipeCollectionRepository {
  final RecipeCollectionService _recipeCollectionService;

  RecipeCollectionRepository(this._recipeCollectionService);

  Future<List<dynamic>> getSavedRecipes() {
    return _recipeCollectionService.fetchSavedRecipes();
  }

  Future<List<dynamic>> getRejectedRecipes() {
    return _recipeCollectionService.fetchRejectedRecipes();
  }
}
