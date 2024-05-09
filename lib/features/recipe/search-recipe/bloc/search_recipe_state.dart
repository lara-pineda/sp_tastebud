part of 'search_recipe_bloc.dart';

abstract class SearchRecipeState extends Equatable {
  const SearchRecipeState();

  @override
  List<Object?> get props => [];
}

class FavoritesInitial extends SearchRecipeState {}

class FavoritesLoading extends SearchRecipeState {
  const FavoritesLoading();
}

class FavoritesAdded extends SearchRecipeState {
  final String uri;

  const FavoritesAdded(this.uri);

  @override
  List<Object?> get props => [uri];
}

class FavoritesError extends SearchRecipeState {
  final String message;

  const FavoritesError(this.message);

  @override
  List<Object?> get props => [message];
}

class RecipeDetailState extends SearchRecipeState {
  final Map<String, dynamic> recipe;
  RecipeDetailState(this.recipe);

  @override
  List<Object> get props => [recipe];
}
