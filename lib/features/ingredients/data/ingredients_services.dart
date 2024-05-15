import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class IngredientsService {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  IngredientsService(this._firebaseAuth, this._firestore);

  Future<Map<String, dynamic>?> getIngredients(String userId) async {
    try {
      DocumentSnapshot snapshot =
          await _firestore.collection('users').doc(userId).get();
      return snapshot.data() as Map<String, dynamic>?;
    } catch (e) {
      throw Exception('Failed to load ingredients: $e');
    }
  }

  Future<void> updatePantryEssentials(
      String userId, List<String> selectedOptions) async {
    try {
      print("UserID 3:");
      print(userId);
      print("received pantry essentials value:");
      print(selectedOptions);
      await _firestore.collection('users').doc(userId).update({
        'pantryEssentials': selectedOptions,
      });
    } catch (e) {
      throw Exception('Failed to update pantry essentials: $e');
    }
  }

  Future<void> updateMeat(String userId, List<String> selectedOptions) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'meat': selectedOptions,
      });
    } catch (e) {
      throw Exception('Failed to update meat: $e');
    }
  }

  Future<void> updateVegetablesAndGreens(
      String userId, List<String> selectedOptions) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'vegetablesAndGreens': selectedOptions,
      });
    } catch (e) {
      throw Exception('Failed to update vegetablesAndGreens: $e');
    }
  }

  Future<void> updateFishAndPoultry(
      String userId, List<String> selectedOptions) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'fishAndPoultry': selectedOptions,
      });
    } catch (e) {
      throw Exception('Failed to update fishAndPoultry: $e');
    }
  }

  Future<void> updateBaking(String userId, List<String> selectedOptions) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'baking': selectedOptions,
      });
    } catch (e) {
      throw Exception('Failed to update baking: $e');
    }
  }
}
