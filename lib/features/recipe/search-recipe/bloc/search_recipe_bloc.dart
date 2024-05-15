import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/extract_recipe_id.dart';
import '../data/search_repository.dart';
import 'package:sp_tastebud/features/recipe-collection/bloc/recipe_collection_bloc.dart';

part 'search_recipe_event.dart';
part 'search_recipe_state.dart';

class SearchRecipeBloc extends Bloc<SearchRecipeEvent, SearchRecipeState> {
  final SearchRecipeRepository _recipeRepository;
  final RecipeCollectionBloc _recipeCollectionBloc;
  late final StreamSubscription recipeCollectionSubscription;

  SearchRecipeBloc(this._recipeRepository, this._recipeCollectionBloc)
      : super(SearchRecipeInitial()) {
    // Listen to recipe collection changes
    recipeCollectionSubscription = _recipeCollectionBloc.stream.listen((state) {
      if (state is SavedRecipesLoaded) {
        add(UpdateRecipeFavoritesFromCollection(state.savedRecipes));
      }
    });

    // Register event handlers
    on<AddToFavorites>(_onAddToFavorites);
    on<AddToRejected>(_onAddToRejected);
    on<RemoveFromFavorites>(_onRemoveFromFavorites);
    on<RemoveFromRejected>(_onRemoveFromRejected);
    on<RecipeSelected>((event, emit) => emit(RecipeDetailState(event.recipe)));
    on<UpdateRecipeFavorites>(_onUpdateRecipeFavorites);
    on<UpdateRecipeFavoritesFromCollection>(
        _onUpdateRecipeFavoritesFromCollection);
  }

  @override
  Future<void> close() {
    recipeCollectionSubscription.cancel();
    return super.close();
  }

  Future<void> _onAddToFavorites(
      AddToFavorites event, Emitter<SearchRecipeState> emit) async {
    emit(FavoritesLoading());
    try {
      await _recipeRepository.addToFavorites(event.recipeName, event.image,
          event.sourceWebsite, event.recipeId, event.recipeUri);
      emit(FavoritesAdded(event.recipeUri));
      _updateRecipeFavoritesState(event.recipeUri, true, emit);
    } catch (e, stacktrace) {
      print('Failed to add to favorites: $e');
      print('Stacktrace: $stacktrace');
      emit(FavoritesError(e.toString()));
    }
  }

  void _onAddToRejected(
      AddToRejected event, Emitter<SearchRecipeState> emit) async {
    try {
      await _recipeRepository.addToRejected(event.recipeName, event.image,
          event.sourceWebsite, event.recipeId, event.recipeUri);
      emit(RejectedAdded(event.recipeUri)); // You need to define this state
    } catch (e) {
      emit(RejectedError(e.toString())); // You need to define this state
    }
  }

  // Future<void> _onRemoveFromRejected(
  //     RemoveFromRejected event, Emitter<SearchRecipeState> emit) async {
  //   emit(
  //       RejectedLoading()); // Emitting a loading state before performing the operation
  //   try {
  //     await _recipeRepository.removeFromRejected(
  //         event.recipeUri); // Assuming recipeUri uniquely identifies the recipe
  //     emit(RejectedRemoved(event
  //         .recipeUri)); // Emitting a state indicating the recipe was successfully removed
  //   } catch (e) {
  //     print('Failed to remove from rejected: $e');
  //     emit(RejectedError(
  //         e.toString())); // Emitting an error state if something goes wrong
  //   }
  // }

  void _onRemoveFromRejected(
      RemoveFromRejected event, Emitter<SearchRecipeState> emit) async {
    emit(
        RejectedLoading()); // Emitting a loading state before performing the operation
    try {
      await _recipeRepository.removeFromRejected(
          event.recipeUri); // Assuming recipeUri uniquely identifies the recipe
      emit(RejectedRemoved(event
          .recipeUri)); // Emitting a state indicating the recipe was successfully removed
    } catch (e) {
      print('Failed to remove from rejected: $e');
      emit(RejectedError(
          e.toString())); // Emitting an error state if something goes wrong
    }
  }

  Future<void> _onRemoveFromFavorites(
      RemoveFromFavorites event, Emitter<SearchRecipeState> emit) async {
    emit(FavoritesLoading()); // Indicate loading state before the operation
    try {
      await _recipeRepository.removeFromFavorites(
          event.recipeUri); // Attempt to remove the recipe from favorites
      emit(FavoritesRemoved(event.recipeUri)); // Emit successful removal state
      // Optionally update the local state list if maintaining a list of favorite recipes within the bloc
      _updateRecipeFavoritesState(event.recipeUri, false, emit);
    } catch (e, stacktrace) {
      print('Failed to remove from favorites: $e');
      print('Stacktrace: $stacktrace');
      emit(FavoritesError(
          e.toString())); // Emit error state with the error message
    }
  }

  Future<void> _onUpdateRecipeFavorites(
      UpdateRecipeFavorites event, Emitter<SearchRecipeState> emit) async {
    _updateRecipeFavoritesState(event.recipeUri, event.isFavorite, emit);
  }

  Future<void> _onUpdateRecipeFavoritesFromCollection(
      UpdateRecipeFavoritesFromCollection event,
      Emitter<SearchRecipeState> emit) async {
    final favoriteUris =
        event.recipes.map((recipe) => recipe['recipeUri']).toList();
    if (state is SearchRecipeLoaded) {
      final loadedState = state as SearchRecipeLoaded;
      final updatedRecipes = loadedState.recipes.map((recipe) {
        return {...recipe, 'isFavorite': favoriteUris.contains(recipe['uri'])};
      }).toList();
      emit(SearchRecipeLoaded(updatedRecipes));
    }
  }

  void _updateRecipeFavoritesState(
      String recipeUri, bool isFavorite, Emitter<SearchRecipeState> emit) {
    if (state is SearchRecipeLoaded) {
      final loadedState = state as SearchRecipeLoaded;
      final updatedRecipes = loadedState.recipes.map((recipe) {
        if (recipe['uri'] == recipeUri) {
          return {...recipe, 'isFavorite': isFavorite};
        }
        return recipe;
      }).toList();
      emit(SearchRecipeLoaded(updatedRecipes));
    }
  }
}
