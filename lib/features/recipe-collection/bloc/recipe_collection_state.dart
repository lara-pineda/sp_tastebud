part of 'recipe_collection_bloc.dart';

abstract class RecipeCollectionState extends Equatable {
  const RecipeCollectionState();

  @override
  List<Object> get props => [];
}

class RecipeCollectionInitial extends RecipeCollectionState {}

class RecipeCollectionLoading extends RecipeCollectionState {}

class SavedRecipesLoaded extends RecipeCollectionState {
  final List<Map<String, dynamic>> savedRecipes;

  SavedRecipesLoaded(this.savedRecipes);

  @override
  List<Object> get props => [savedRecipes];
}

class RejectedRecipesLoaded extends RecipeCollectionState {
  final List<Map<String, dynamic>> rejectedRecipes;

  RejectedRecipesLoaded(this.rejectedRecipes);

  @override
  List<Object> get props => [rejectedRecipes];
}

class RecipeCollectionError extends RecipeCollectionState {
  final String error;

  RecipeCollectionError(this.error);

  @override
  List<Object> get props => [error];
}
