part of 'ingredients_bloc.dart';

abstract class IngredientsState {}

class IngredientsInitial extends IngredientsState {}

class IngredientsLoaded extends IngredientsState {
  final List<bool> pantryEssentials;
  final List<bool> meat;
  final List<bool> vegetables;

  IngredientsLoaded(this.pantryEssentials, this.meat, this.vegetables);
}

class IngredientsUpdated extends IngredientsState {}

class IngredientsError extends IngredientsState {
  final String error;
  IngredientsError(this.error);
}
