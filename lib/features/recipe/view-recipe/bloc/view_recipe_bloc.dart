import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../search-recipe/recipe_search_api.dart';
import '../data/view_recipe_repository.dart';

part 'view_recipe_event.dart';
part 'view_recipe_state.dart';

class ViewRecipeBloc extends Bloc<ViewRecipeEvent, ViewRecipeState> {
  final ViewRecipeRepository _viewRecipeRepository;

  ViewRecipeBloc(this._viewRecipeRepository) : super(RejectedInitial()) {
    on<FetchRecipe>(_onFetchRecipe);
    on<AddToRejected>(_onAddToRejected);
  }

  Future<void> _onFetchRecipe(
      FetchRecipe event, Emitter<ViewRecipeState> emit) async {
    emit(RecipeLoading());
    try {
      print("in view recipe bloc");
      print("recipe ID: ${event.recipeId}");
      final data = await _viewRecipeRepository.fetchRecipeById(event.recipeId);
      emit(RecipeLoaded(data));
    } catch (e) {
      emit(RecipeError(e.toString()));
    }
  }

  Future<void> _onAddToRejected(
      AddToRejected event, Emitter<ViewRecipeState> emit) async {
    try {
      await _viewRecipeRepository.addToRejected(
          event.recipeName, event.image, event.sourceWebsite, event.recipeId);

      // print("in bloc");
      // print(event.recipeName);
      // print(event.image);
      // print(event.sourceWebsite);
      // print(event.recipeId);

      emit(RejectedAdded(event.recipeId));
    } catch (e, stacktrace) {
      // This will print more detailed error information
      print('Failed to add to favorites: $e');
      print('Stacktrace: $stacktrace');
      emit(RejectedError(e.toString()));
    }
  }
}
