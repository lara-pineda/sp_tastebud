import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RecipeCollectionServices {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth;

  RecipeCollectionServices(this._firestore, this._firebaseAuth);

  Stream<List<Map<String, dynamic>>> getSavedRecipesStream() {
    User? user = _firebaseAuth.currentUser;
    if (user == null) {
      return Stream.error(Exception("User not logged in"));
    }
    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('savedRecipes')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList())
        .handleError((error) => throw error)
        .asBroadcastStream(); // Make it a broadcast stream
  }

  Stream<List<Map<String, dynamic>>> getRejectedRecipesStream() {
    User? user = _firebaseAuth.currentUser;
    if (user == null) {
      return Stream.error(Exception("User not logged in"));
    }
    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('rejectedRecipes')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList())
        .handleError((error) => throw error)
        .asBroadcastStream(); // Make it a broadcast stream
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

  Future<bool> isRecipeInRejected(String recipeId) async {
    User? user = _firebaseAuth.currentUser;
    if (user == null) {
      throw Exception('No user logged in!');
    }

    DocumentSnapshot doc = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('rejectedRecipes')
        .doc(recipeId)
        .get();

    return doc.exists;
  }
}
