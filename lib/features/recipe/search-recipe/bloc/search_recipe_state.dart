part of 'search_recipe_bloc.dart';

abstract class SearchRecipeState extends Equatable {
  const SearchRecipeState();

  @override
  List<Object?> get props => [];
}

class FavoritesInitial extends SearchRecipeState {}

class FavoritesAdded extends SearchRecipeState {
  final String recipeId;

  const FavoritesAdded(this.recipeId);

  @override
  List<Object?> get props => [recipeId];
}

class FavoritesError extends SearchRecipeState {
  final String message;

  const FavoritesError(this.message);

  @override
  List<Object?> get props => [message];
}
