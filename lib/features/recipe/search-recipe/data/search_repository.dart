import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchRecipeRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth;

  SearchRecipeRepository(this._firestore, this._firebaseAuth);

  Future<void> addToFavorites(String recipeName, String image, String source,
      String recipeId, String recipeUri) async {
    User? user = _firebaseAuth.currentUser;
    if (user == null) {
      throw Exception('No user logged in!');
    }

    DocumentReference recipeRef = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('savedRecipes')
        .doc(recipeId);

    DocumentSnapshot snapshot = await recipeRef.get();
    if (snapshot.exists) {
      throw Exception('Recipe already in favorites.');
    }

    await recipeRef.set({
      'recipeName': recipeName,
      'image': image,
      'source': source,
      'recipeUri': recipeUri,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future<void> addToRejected(String recipeName, String image, String source,
      String recipeId, String recipeUri) async {
    User? user = _firebaseAuth.currentUser;
    if (user == null) {
      throw Exception('No user logged in!');
    }

    DocumentReference recipeRef = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('rejectedRecipes')
        .doc(recipeId);

    DocumentSnapshot snapshot = await recipeRef.get();
    if (snapshot.exists) {
      throw Exception('Recipe already in rejected.');
    }

    await recipeRef.set({
      'recipeName': recipeName,
      'image': image,
      'source': source,
      'recipeUri': recipeUri,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future<void> removeFromFavorites(String recipeId) async {
    try {
      User? user = _firebaseAuth.currentUser;
      if (user == null) {
        throw Exception('No user logged in!');
      }

      DocumentReference recipeRef = _firestore
          .collection('users')
          .doc(user.uid)
          .collection('savedRecipes')
          .doc(recipeId);

      DocumentSnapshot snapshot = await recipeRef.get();
      if (!snapshot.exists) {
        throw Exception('Recipe not found in favorites.');
      }

      await recipeRef.delete();
    } catch (e) {
      throw e;
    }
  }

  Future<void> removeFromRejected(String recipeId) async {
    try {
      User? user = _firebaseAuth.currentUser;
      if (user == null) {
        throw Exception('No user logged in!');
      }

      DocumentReference recipeRef = _firestore
          .collection('users')
          .doc(user.uid)
          .collection('rejectedRecipes')
          .doc(recipeId);

      await recipeRef.delete();
    } catch (e) {
      throw Exception('Error removing recipe from rejected.');
    }
  }
}
