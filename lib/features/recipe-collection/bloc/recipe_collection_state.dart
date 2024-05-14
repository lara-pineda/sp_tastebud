part of 'recipe_collection_bloc.dart';

abstract class RecipeCollectionState extends Equatable {
  const RecipeCollectionState();

  @override
  List<Object?> get props => [];
}

class RecipeCollectionInitial extends RecipeCollectionState {}

class RecipeCollectionLoading extends RecipeCollectionState {}

class SavedRecipesLoaded extends RecipeCollectionState {
  final List<Map<String, dynamic>> savedRecipes;

  const SavedRecipesLoaded(this.savedRecipes);

  @override
  List<Object> get props => [savedRecipes];
}

class RejectedRecipesLoaded extends RecipeCollectionState {
  final List<Map<String, dynamic>> rejectedRecipes;

  const RejectedRecipesLoaded(this.rejectedRecipes);

  @override
  List<Object> get props => [rejectedRecipes];
}

class RecipeCollectionError extends RecipeCollectionState {
  final String error;

  const RecipeCollectionError(this.error);

  @override
  List<Object> get props => [error];
}
