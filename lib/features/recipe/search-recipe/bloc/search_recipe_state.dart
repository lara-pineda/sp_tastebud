part of 'search_recipe_bloc.dart';

abstract class SearchRecipeState extends Equatable {
  const SearchRecipeState();

  @override
  List<Object> get props => [];
}

class SearchRecipeInitial extends SearchRecipeState {}

class SearchRecipeLoaded extends SearchRecipeState {
  final List<Map<String, dynamic>> recipes;

  SearchRecipeLoaded(this.recipes);

  @override
  List<Object> get props => [recipes];
}

class RecipeDetailState extends SearchRecipeState {
  final Map<String, dynamic> recipe;

  RecipeDetailState(this.recipe);

  @override
  List<Object> get props => [recipe];
}

class FavoritesLoading extends SearchRecipeState {}

class FavoritesAdded extends SearchRecipeState {
  final String recipeUri;

  FavoritesAdded(this.recipeUri);

  @override
  List<Object> get props => [recipeUri];
}

class FavoritesRemoved extends SearchRecipeState {
  final String recipeUri;

  FavoritesRemoved(this.recipeUri);

  @override
  List<Object> get props => [recipeUri];
}

class FavoritesError extends SearchRecipeState {
  final String error;

  FavoritesError(this.error);

  @override
  List<Object> get props => [error];
}
