part of 'ingredients_bloc.dart';

abstract class IngredientsState {}

class IngredientsInitial extends IngredientsState {}

class IngredientsLoaded extends IngredientsState {
  final List pantryEssentials;
  final List meat;
  final List vegetablesAndGreens;
  final List fishAndPoultry;
  final List baking;

  IngredientsLoaded(this.pantryEssentials, this.meat, this.vegetablesAndGreens,
      this.fishAndPoultry, this.baking);
}

class IngredientsUpdated extends IngredientsState {
  final List pantryEssentials;
  final List meat;
  final List vegetablesAndGreens;
  final List fishAndPoultry;
  final List baking;

  IngredientsUpdated(this.pantryEssentials, this.meat, this.vegetablesAndGreens,
      this.fishAndPoultry, this.baking);
}

class IngredientsError extends IngredientsState {
  final String error;
  IngredientsError(this.error);
}
