part of 'search_recipe_bloc.dart';

abstract class SearchRecipeEvent extends Equatable {
  const SearchRecipeEvent();

  @override
  List<Object?> get props => [];
}

class AddToFavorites extends SearchRecipeEvent {
  final String recipeName;
  final String image;
  final String sourceWebsite;
  final String recipeId;

  AddToFavorites(
      this.recipeName, this.image, this.sourceWebsite, this.recipeId);

  @override
  List<Object> get props => [recipeName, image, recipeId];
}
