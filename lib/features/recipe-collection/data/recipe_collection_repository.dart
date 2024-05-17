import 'dart:async';
import 'recipe_collection_services.dart';

class RecipeCollectionRepository {
  final RecipeCollectionServices _repository;

  RecipeCollectionRepository(this._repository);

  Stream<List<Map<String, dynamic>>> getSavedRecipesStream() {
    return _repository.getSavedRecipesStream();
  }

  Stream<List<Map<String, dynamic>>> getRejectedRecipesStream() {
    return _repository.getRejectedRecipesStream();
  }

  Future<bool> isRecipeInFavorites(String recipeId) {
    return _repository.isRecipeInFavorites(recipeId);
  }

  Future<bool> isRecipeInRejected(String recipeId) {
    return _repository.isRecipeInRejected(recipeId);
  }
}
