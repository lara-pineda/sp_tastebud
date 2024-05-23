import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      emit(RejectedAdded(event.recipeId));
    } catch (e) {
      emit(RejectedError(e.toString()));
    }
  }
}
