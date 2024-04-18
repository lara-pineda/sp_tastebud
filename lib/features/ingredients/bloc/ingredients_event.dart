part of 'ingredients_bloc.dart';

abstract class IngredientsEvent {}

class LoadIngredients extends IngredientsEvent {}

class UpdateIngredients extends IngredientsEvent {
  final List<String> pantryEssentials;
  final List<String> meat;
  final List<String> vegetables;

  UpdateIngredients(this.pantryEssentials, this.meat, this.vegetables);
}
