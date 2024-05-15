import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RecipeCollectionRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth;

  RecipeCollectionRepository(this._firestore, this._firebaseAuth);

  Stream<List<Map<String, dynamic>>> getSavedRecipesStream() {
    var controller = StreamController<List<Map<String, dynamic>>>();
    User? user = _firebaseAuth.currentUser;
    if (user == null) {
      controller.addError(Exception("User not logged in"));
      return controller.stream;
    }
    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('savedRecipes')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList())
        .handleError((error) {
      controller.addError(error);
    });
  }

  Stream<List<Map<String, dynamic>>> getRejectedRecipesStream() {
    var controller = StreamController<List<Map<String, dynamic>>>();
    User? user = _firebaseAuth.currentUser;
    if (user == null) {
      controller.addError(Exception("User not logged in"));
      return controller.stream;
    }
    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('rejectedRecipes')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList())
        .handleError((error) {
      controller.addError(error);
    });
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
