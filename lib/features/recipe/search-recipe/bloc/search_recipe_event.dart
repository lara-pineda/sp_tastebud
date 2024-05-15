part of 'search_recipe_bloc.dart';

abstract class SearchRecipeEvent extends Equatable {
  const SearchRecipeEvent();

  @override
  List<Object> get props => [];
}

class AddToFavorites extends SearchRecipeEvent {
  final String recipeName;
  final String image;
  final String sourceWebsite;
  final String recipeId;
  final String recipeUri;

  AddToFavorites(this.recipeName, this.image, this.sourceWebsite, this.recipeId,
      this.recipeUri);
}

class RemoveFromFavorites extends SearchRecipeEvent {
  final String recipeUri;

  RemoveFromFavorites(this.recipeUri);
}

class RecipeSelected extends SearchRecipeEvent {
  final Map<String, dynamic> recipe;

  RecipeSelected(this.recipe);
}

class UpdateRecipeFavorites extends SearchRecipeEvent {
  final String recipeUri;
  final bool isFavorite;

  UpdateRecipeFavorites(this.recipeUri, this.isFavorite);
}

class UpdateRecipeFavoritesFromCollection extends SearchRecipeEvent {
  final List<Map<String, dynamic>> recipes;

  UpdateRecipeFavoritesFromCollection(this.recipes);
}
