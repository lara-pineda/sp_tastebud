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
    on<RemoveFromFavorites>(_onRemoveFromFavorites);
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

  Future<void> _onRemoveFromFavorites(
      RemoveFromFavorites event, Emitter<SearchRecipeState> emit) async {
    emit(FavoritesLoading());
    try {
      await _recipeRepository.removeFromFavorites(event.recipeUri);
      emit(FavoritesRemoved(event.recipeUri));
      _updateRecipeFavoritesState(event.recipeUri, false, emit);
    } catch (e, stacktrace) {
      print('Failed to remove from favorites: $e');
      print('Stacktrace: $stacktrace');
      emit(FavoritesError(e.toString()));
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
