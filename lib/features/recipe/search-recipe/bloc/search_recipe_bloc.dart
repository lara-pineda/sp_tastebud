import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'search_recipe_event.dart';
part 'search_recipe_state.dart';

class SearchRecipeBloc extends Bloc<SearchRecipeEvent, SearchRecipeState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  SearchRecipeBloc() : super(FavoritesInitial());

  Stream<SearchRecipeState> mapEventToState(SearchRecipeEvent event) async* {
    if (event is AddToFavorites) {
      yield* _mapAddToFavoritesToState(event);
    }
  }

  Stream<SearchRecipeState> _mapAddToFavoritesToState(
      AddToFavorites event) async* {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        yield FavoritesError('No user logged in!');
        return;
      }

      DocumentReference recipeRef = _firestore
          .collection('users')
          .doc(user.uid)
          .collection('savedRecipes')
          .doc(event.recipeId);

      DocumentSnapshot snapshot = await recipeRef.get();
      if (!snapshot.exists) {
        await recipeRef.set({
          'recipeId': event.recipeId,
          'timestamp': FieldValue.serverTimestamp(),
        });
        yield FavoritesAdded(event.recipeId);
      } else {
        yield FavoritesError('Recipe already in favorites.');
      }
    } catch (e) {
      yield FavoritesError('Error adding to favorites: $e');
    }
  }
}
