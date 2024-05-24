import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:TasteBud/core/utils/extract_recipe_id.dart';

part 'recipe_event.dart';
part 'recipe_state.dart';

class RecipeCardBloc extends Bloc<RecipeCardEvent, RecipeCardState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  RecipeCardBloc() : super(RecipeCardInitial()) {
    on<ToggleFavorite>(_onToggleFavorite);
    on<ToggleReject>(_onToggleReject);
    on<LoadInitialData>(_onLoadInitialData);
  }

  Future<void> _onToggleFavorite(
      ToggleFavorite event, Emitter<RecipeCardState> emit) async {
    final user = _auth.currentUser;
    if (user == null) {
      emit(RecipeCardError('User not authenticated'));
      return;
    }

    final recipeId = extractRecipeIdUsingRegExp(event.recipeUri);
    final recipeRef = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('savedRecipes')
        .doc(recipeId);

    try {
      final snapshot = await recipeRef.get();
      if (snapshot.exists) {
        await recipeRef.delete();
        _removeFavorite(recipeId, emit);
      } else {
        await recipeRef.set({
          'recipeName': event.recipeName,
          'image': event.imageUrl,
          'source': event.sourceWebsite,
          'recipeUri': event.recipeUri,
          'timestamp': FieldValue.serverTimestamp(),
        });
        _addFavorite(recipeId, emit);
      }
    } catch (e) {
      emit(RecipeCardError(e.toString()));
    }
  }

  Future<void> _onToggleReject(
      ToggleReject event, Emitter<RecipeCardState> emit) async {
    final user = _auth.currentUser;
    if (user == null) {
      emit(RecipeCardError('User not authenticated'));
      return;
    }

    final recipeId = extractRecipeIdUsingRegExp(event.recipeUri);
    final recipeRef = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('rejectedRecipes')
        .doc(recipeId);

    try {
      final snapshot = await recipeRef.get();
      if (snapshot.exists) {
        await recipeRef.delete();
        _removeRejected(recipeId, emit);
      } else {
        await recipeRef.set({
          'recipeName': event.recipeName,
          'image': event.imageUrl,
          'source': event.sourceWebsite,
          'recipeUri': event.recipeUri,
          'timestamp': FieldValue.serverTimestamp(),
        });
        _addRejected(recipeId, emit);
      }
    } catch (e) {
      emit(RecipeCardError(e.toString()));
    }
  }

  Future<void> _onLoadInitialData(
      LoadInitialData event, Emitter<RecipeCardState> emit) async {
    final user = _auth.currentUser;
    if (user == null) {
      emit(RecipeCardError('User not authenticated'));
      return;
    }

    try {
      final favoritesCollection = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('savedRecipes')
          .get();
      final rejectedCollection = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('rejectedRecipes')
          .get();

      final favorites = favoritesCollection.docs.map((doc) => doc.id).toSet();
      final rejected = rejectedCollection.docs.map((doc) => doc.id).toSet();
      emit(RecipeCardUpdated(favorites, rejected));
    } catch (e) {
      emit(RecipeCardError(e.toString()));
    }
  }

  void _addFavorite(String recipeId, Emitter<RecipeCardState> emit) {
    if (state is RecipeCardUpdated) {
      final currentState = state as RecipeCardUpdated;
      final updatedFavorites = currentState.favorites.toSet()..add(recipeId);
      emit(currentState.copyWith(favorites: updatedFavorites));
    }
  }

  void _removeFavorite(String recipeId, Emitter<RecipeCardState> emit) {
    if (state is RecipeCardUpdated) {
      final currentState = state as RecipeCardUpdated;
      final updatedFavorites = currentState.favorites.toSet()..remove(recipeId);
      emit(currentState.copyWith(favorites: updatedFavorites));
    }
  }

  void _addRejected(String recipeId, Emitter<RecipeCardState> emit) {
    if (state is RecipeCardUpdated) {
      final currentState = state as RecipeCardUpdated;
      final updatedRejected = currentState.rejected.toSet()..add(recipeId);
      emit(currentState.copyWith(rejected: updatedRejected));
    }
  }

  void _removeRejected(String recipeId, Emitter<RecipeCardState> emit) {
    if (state is RecipeCardUpdated) {
      final currentState = state as RecipeCardUpdated;
      final updatedRejected = currentState.rejected.toSet()..remove(recipeId);
      emit(currentState.copyWith(rejected: updatedRejected));
    }
  }
}
