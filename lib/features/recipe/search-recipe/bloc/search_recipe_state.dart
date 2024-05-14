part of 'search_recipe_bloc.dart';

abstract class SearchRecipeState extends Equatable {
  const SearchRecipeState();

  @override
  List<Object?> get props => [];
}

class SearchRecipeInitial extends SearchRecipeState {}

class SearchRecipeLoading extends SearchRecipeState {
  const SearchRecipeLoading();
}

class SearchRecipeLoaded extends UserProfileState {
  SearchRecipeLoaded();
  // final List dietaryPreferences;
  // final List allergies;
  // final List macronutrients;
  // final List micronutrients;
  //
  // UserProfileLoaded(this.dietaryPreferences, this.allergies,
  //     this.macronutrients, this.micronutrients);
}

class SearchRecipeError extends SearchRecipeState {
  final String message;

  const SearchRecipeError(this.message);

  @override
  List<Object?> get props => [message];
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

class FavoritesRemoved extends SearchRecipeState {
  final String uri;

  const FavoritesRemoved(this.uri);

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
