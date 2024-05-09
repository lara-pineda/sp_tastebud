part of 'view_recipe_bloc.dart';

abstract class ViewRecipeEvent extends Equatable {
  const ViewRecipeEvent();

  @override
  List<Object?> get props => [];
}

class AddToRejected extends ViewRecipeEvent {
  final String recipeName;
  final String image;
  final String sourceWebsite;
  final String recipeId;

  AddToRejected(this.recipeName, this.image, this.sourceWebsite, this.recipeId);

  @override
  List<Object> get props => [recipeName, image, recipeId];
}

class FetchRecipe extends ViewRecipeEvent {
  final String recipeId;

  FetchRecipe(this.recipeId);

  @override
  List<Object> get props => [recipeId];
}
