import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:TasteBud/features/recipe-collection/data/recipe_collection_repository.dart';

part 'recipe_collection_event.dart';
part 'recipe_collection_state.dart';

class RecipeCollectionBloc
    extends Bloc<RecipeCollectionEvent, RecipeCollectionState> {
  final RecipeCollectionRepository _recipeCollectionRepository;

  StreamSubscription<List<Map<String, dynamic>>>? _savedRecipesSubscription;
  StreamSubscription<List<Map<String, dynamic>>>? _rejectedRecipesSubscription;

  RecipeCollectionBloc(this._recipeCollectionRepository)
      : super(RecipeCollectionInitial()) {
    // Register event handlers
    on<FetchSavedRecipes>(_fetchSavedRecipes);
    on<FetchRejectedRecipes>(_fetchRejectedRecipes);
    on<SavedRecipesUpdated>(_onSavedRecipesUpdated);
    on<RejectedRecipesUpdated>(_onRejectedRecipesUpdated);
  }

  @override
  Future<void> close() {
    _savedRecipesSubscription?.cancel();
    _rejectedRecipesSubscription?.cancel();
    return super.close();
  }

  Future<void> _fetchSavedRecipes(
      FetchSavedRecipes event, Emitter<RecipeCollectionState> emit) async {
    emit(RecipeCollectionLoading());
    try {
      await _savedRecipesSubscription?.cancel();
      _savedRecipesSubscription =
          _recipeCollectionRepository.getSavedRecipesStream().listen(
        (recipes) {
          add(SavedRecipesUpdated(recipes));
        },
        onError: (error) {
          emit(RecipeCollectionError(
              'Failed to load saved recipes: ${error.toString()}'));
        },
      );
    } catch (e) {
      emit(RecipeCollectionError(
          'Failed to load saved recipes: ${e.toString()}'));
    }
  }

  Future<void> _fetchRejectedRecipes(
      FetchRejectedRecipes event, Emitter<RecipeCollectionState> emit) async {
    emit(RecipeCollectionLoading());
    try {
      await _rejectedRecipesSubscription?.cancel();
      _rejectedRecipesSubscription =
          _recipeCollectionRepository.getRejectedRecipesStream().listen(
        (recipes) {
          add(RejectedRecipesUpdated(recipes));
        },
        onError: (error) {
          emit(RecipeCollectionError(
              'Failed to load rejected recipes: ${error.toString()}'));
        },
      );
    } catch (e) {
      emit(RecipeCollectionError(
          'Failed to load rejected recipes: ${e.toString()}'));
    }
  }

  void _onSavedRecipesUpdated(
      SavedRecipesUpdated event, Emitter<RecipeCollectionState> emit) {
    emit(SavedRecipesLoaded(event.recipes));
  }

  void _onRejectedRecipesUpdated(
      RejectedRecipesUpdated event, Emitter<RecipeCollectionState> emit) {
    emit(RejectedRecipesLoaded(event.recipes));
  }
}
