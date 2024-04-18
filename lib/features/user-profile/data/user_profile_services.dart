import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfileService {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  UserProfileService(this._firebaseAuth, this._firestore);

  Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    try {
      DocumentSnapshot snapshot =
          await _firestore.collection('users').doc(userId).get();
      return snapshot.data() as Map<String, dynamic>?;
    } catch (e) {
      throw Exception('Failed to load user profile: $e');
    }
  }

  Future<void> updateDietPref(
      String userId, List<String> selectedOptions) async {
    try {
      print("UserID 3:");
      print(userId);
      await _firestore.collection('users').doc(userId).update({
        'dietaryPreferences': selectedOptions,
      });
    } catch (e) {
      throw Exception('Failed to update diet preferences: $e');
    }
  }

  Future<void> updateAllergies(
      String userId, List<String> selectedOptions) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'allergies': selectedOptions,
      });
    } catch (e) {
      throw Exception('Failed to update allergies: $e');
    }
  }

  Future<void> updateMacronutrients(
      String userId, List<String> selectedOptions) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'macronutrients': selectedOptions,
      });
    } catch (e) {
      throw Exception('Failed to update macronutrients: $e');
    }
  }

  Future<void> updateMicronutrients(
      String userId, List<String> selectedOptions) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'micronutrients': selectedOptions,
      });
    } catch (e) {
      throw Exception('Failed to update micronutrients: $e');
    }
  }
}
