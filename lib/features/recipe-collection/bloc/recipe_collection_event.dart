part of 'recipe_collection_bloc.dart';

abstract class RecipeCollectionEvent {}

class FetchSavedRecipes extends RecipeCollectionEvent {
  final String userId;

  FetchSavedRecipes(this.userId);
}

class FetchRejectedRecipes extends RecipeCollectionEvent {
  final String userId;

  FetchRejectedRecipes(this.userId);
}
