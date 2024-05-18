part of 'recipe_bloc.dart';

abstract class RecipeCardState extends Equatable {
  const RecipeCardState();

  @override
  List<Object> get props => [];
}

class RecipeCardInitial extends RecipeCardState {}

class RecipeCardUpdated extends RecipeCardState {
  final Set<String> favorites;
  final Set<String> rejected;

  const RecipeCardUpdated(this.favorites, this.rejected);

  @override
  List<Object> get props => [favorites, rejected];

  RecipeCardUpdated copyWith({
    Set<String>? favorites,
    Set<String>? rejected,
  }) {
    return RecipeCardUpdated(
      favorites ?? this.favorites,
      rejected ?? this.rejected,
    );
  }
}

class RecipeCardError extends RecipeCardState {
  final String message;

  const RecipeCardError(this.message);

  @override
  List<Object> get props => [message];
}
