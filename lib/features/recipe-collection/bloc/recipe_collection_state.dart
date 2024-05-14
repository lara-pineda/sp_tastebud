part of 'recipe_collection_bloc.dart';

abstract class RecipeCollectionState {}

class RecipeCollectionInitial extends RecipeCollectionState {}

class RecipeCollectionLoading extends RecipeCollectionState {}

class SavedRecipesLoaded extends RecipeCollectionState {
  final List<dynamic> savedRecipes;

  SavedRecipesLoaded(this.savedRecipes);
}

class RejectedRecipesLoaded extends RecipeCollectionState {
  final List<dynamic> rejectedRecipes;

  RejectedRecipesLoaded(this.rejectedRecipes);
}

class RecipeCollectionError extends RecipeCollectionState {
  final String error;

  RecipeCollectionError(this.error);
}
