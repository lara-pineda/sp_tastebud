part of 'recipe_collection_bloc.dart';

abstract class RecipeCollectionEvent {}

class FetchSavedRecipes extends RecipeCollectionEvent {}

class FetchRejectedRecipes extends RecipeCollectionEvent {}
