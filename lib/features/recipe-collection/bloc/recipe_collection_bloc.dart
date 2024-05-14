import 'package:bloc/bloc.dart';
import 'package:sp_tastebud/features/recipe-collection/data/recipe_collection_repository.dart';

part 'recipe_collection_event.dart';
part 'recipe_collection_state.dart';

class RecipeCollectionBloc
    extends Bloc<RecipeCollectionEvent, RecipeCollectionState> {
  final RecipeCollectionRepository _recipeCollectionRepository;

  RecipeCollectionBloc(this._recipeCollectionRepository)
      : super(RecipeCollectionInitial()) {
    on<FetchSavedRecipes>(_fetchSavedRecipes);
    on<FetchRejectedRecipes>(_fetchRejectedRecipes);
  }

  Future<void> _fetchSavedRecipes(
      FetchSavedRecipes event, Emitter<RecipeCollectionState> emit) async {
    emit(RecipeCollectionLoading());
    try {
      var savedRecipes = await _recipeCollectionRepository.getSavedRecipes();

      print("saved recipes:");
      print(savedRecipes);

      emit(SavedRecipesLoaded(savedRecipes));
    } catch (e) {
      emit(RecipeCollectionError(
          'Failed to load saved recipes: ${e.toString()}'));
    }
  }

  Future<void> _fetchRejectedRecipes(
      FetchRejectedRecipes event, Emitter<RecipeCollectionState> emit) async {
    emit(RecipeCollectionLoading());
    try {
      var rejectedRecipes =
          await _recipeCollectionRepository.getRejectedRecipes();

      print("rejected recipes:");
      print(rejectedRecipes);

      emit(RejectedRecipesLoaded(rejectedRecipes));
    } catch (e) {
      emit(RecipeCollectionError(
          'Failed to load rejected recipes: ${e.toString()}'));
    }
  }
}
