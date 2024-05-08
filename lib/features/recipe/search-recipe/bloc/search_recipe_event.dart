part of 'search_recipe_bloc.dart';

abstract class SearchRecipeEvent extends Equatable {
  const SearchRecipeEvent();

  @override
  List<Object?> get props => [];
}

class AddToFavorites extends SearchRecipeEvent {
  final String recipeId;

  const AddToFavorites(this.recipeId);

  @override
  List<Object?> get props => [recipeId];
}
