part of 'recipe_bloc.dart';

abstract class RecipeCardEvent extends Equatable {
  const RecipeCardEvent();

  @override
  List<Object> get props => [];
}

class ToggleFavorite extends RecipeCardEvent {
  final String recipeName;
  final String imageUrl;
  final String sourceWebsite;
  final String recipeUri;

  const ToggleFavorite({
    required this.recipeName,
    required this.imageUrl,
    required this.sourceWebsite,
    required this.recipeUri,
  });

  @override
  List<Object> get props => [recipeName, imageUrl, sourceWebsite, recipeUri];
}

class ToggleReject extends RecipeCardEvent {
  final String recipeName;
  final String imageUrl;
  final String sourceWebsite;
  final String recipeUri;

  const ToggleReject({
    required this.recipeName,
    required this.imageUrl,
    required this.sourceWebsite,
    required this.recipeUri,
  });

  @override
  List<Object> get props => [recipeName, imageUrl, sourceWebsite, recipeUri];
}

class LoadInitialData extends RecipeCardEvent {}
