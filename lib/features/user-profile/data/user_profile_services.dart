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

  Future<void> changeEmail(
      String currentEmail, String newEmail, String password) async {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      try {
        final credential = EmailAuthProvider.credential(
          email: currentEmail,
          password: password,
        );

        // Reauthenticate the user
        await user.reauthenticateWithCredential(credential);

        // Update the email
        await user.verifyBeforeUpdateEmail(newEmail);

        // Update email in Firestore
        await _firestore
            .collection('users')
            .doc(user.uid)
            .update({'email': newEmail});
      } catch (e) {
        throw Exception(e);
      }
    }
  }

  Future<void> updateDietPref(
      String userId, List<String> selectedOptions) async {
    try {
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
