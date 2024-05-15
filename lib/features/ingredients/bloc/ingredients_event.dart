part of 'ingredients_bloc.dart';

abstract class IngredientsEvent {}

class LoadIngredients extends IngredientsEvent {}

class UpdateIngredients extends IngredientsEvent {
  final List<String> pantryEssentials;
  final List<String> meat;
  final List<String> vegetablesAndGreens;
  final List<String> fishAndPoultry;
  final List<String> baking;

  UpdateIngredients(this.pantryEssentials, this.meat, this.vegetablesAndGreens,
      this.fishAndPoultry, this.baking);
}
