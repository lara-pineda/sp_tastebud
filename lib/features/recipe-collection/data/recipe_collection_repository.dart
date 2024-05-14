import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'recipe_collection_services.dart';

class RecipeCollectionRepository {
  // final RecipeCollectionService _recipeCollectionService;

  // RecipeCollectionRepository(this._recipeCollectionService);

  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth;

  RecipeCollectionRepository(this._firestore, this._firebaseAuth);

  Stream<List<Map<String, dynamic>>> getSavedRecipesStream() {
    try {
      User? user = _firebaseAuth.currentUser;

      print('user: $user');

      if (user == null) throw Exception("User not logged in");

      return _firestore
          .collection('users')
          .doc(user.uid)
          .collection('savedRecipes')
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => doc.data() as Map<String, dynamic>)
              .toList());
    } catch (e) {
      throw (e);
    }
  }

  Stream<List<Map<String, dynamic>>> getRejectedRecipesStream() {
    try {
      User? user = _firebaseAuth.currentUser;

      print('user: $user');

      if (user == null) throw Exception("User not logged in");

      return _firestore
          .collection('users')
          .doc(user.uid)
          .collection('rejectedRecipes')
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => doc.data() as Map<String, dynamic>)
              .toList());
    } catch (e) {
      throw (e);
    }
  }

  Future<bool> isRecipeInFavorites(String recipeId) async {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      throw Exception('No user logged in!');
    }

    final doc = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('savedRecipes')
        .doc(recipeId)
        .get();

    return doc.exists;
  }
}
