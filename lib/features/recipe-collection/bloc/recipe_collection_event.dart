part of 'recipe_collection_bloc.dart';

abstract class RecipeCollectionEvent extends Equatable {
  const RecipeCollectionEvent();

  @override
  List<Object?> get props => [];
}

class FetchSavedRecipes extends RecipeCollectionEvent {}

class FetchRejectedRecipes extends RecipeCollectionEvent {}

class SavedRecipesUpdated extends RecipeCollectionEvent {
  final List<Map<String, dynamic>> recipes;

  const SavedRecipesUpdated(this.recipes);

  @override
  List<Object> get props => [recipes];
}

class RejectedRecipesUpdated extends RecipeCollectionEvent {
  final List<Map<String, dynamic>> recipes;

  const RejectedRecipesUpdated(this.recipes);

  @override
  List<Object> get props => [recipes];
}
