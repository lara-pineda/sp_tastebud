part of 'view_recipe_bloc.dart';

abstract class ViewRecipeState extends Equatable {
  const ViewRecipeState();

  @override
  List<Object?> get props => [];
}

class RejectedInitial extends ViewRecipeState {}

class RejectedLoading extends ViewRecipeState {
  const RejectedLoading();
}

class RejectedAdded extends ViewRecipeState {
  final String uri;

  const RejectedAdded(this.uri);

  @override
  List<Object?> get props => [uri];
}

class RejectedError extends ViewRecipeState {
  final String message;

  const RejectedError(this.message);

  @override
  List<Object?> get props => [message];
}

class RecipeInitial extends ViewRecipeState {}

// State to indicate loading
class RecipeLoading extends ViewRecipeState {}

class RecipeLoaded extends ViewRecipeState {
  // State to indicate data is loaded
  final Map<String, dynamic> recipe;

  const RecipeLoaded(this.recipe);

  @override
  List<Object?> get props => [recipe];
}

class RecipeError extends ViewRecipeState {
  // State for handling errors
  final String error;

  const RecipeError(this.error);

  @override
  List<Object?> get props => [error];
}
