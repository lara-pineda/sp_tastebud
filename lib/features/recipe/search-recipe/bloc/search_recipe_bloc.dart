import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/search_repository.dart';

part 'search_recipe_event.dart';
part 'search_recipe_state.dart';

class SearchRecipeBloc extends Bloc<SearchRecipeEvent, SearchRecipeState> {
  final SearchRecipeRepository _recipeRepository;

  SearchRecipeBloc(this._recipeRepository) : super(FavoritesInitial()) {
    on<AddToFavorites>(_onAddToFavorites);
    on<RecipeSelected>((event, emit) => emit(RecipeDetailState(event.recipe)));
  }

  Future<void> _onAddToFavorites(
      AddToFavorites event, Emitter<SearchRecipeState> emit) async {
    // Emit loading state before the process starts
    emit(FavoritesLoading());
    try {
      await _recipeRepository.addToFavorites(
          event.recipeName, event.image, event.sourceWebsite, event.recipeId);

      // print("in bloc");
      // print(event.recipeName);
      // print(event.image);
      // print(event.sourceWebsite);
      // print(event.recipeId);

      emit(FavoritesAdded(event.recipeId));
    } catch (e, stacktrace) {
      // This will print more detailed error information
      print('Failed to add to favorites: $e');
      print('Stacktrace: $stacktrace');
      emit(FavoritesError(e.toString()));
    }
  }
}
