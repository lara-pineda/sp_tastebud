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

  Future<void> updateUserProfile(
      String userId, List<String> selectedOptions) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'dietaryPreferences': selectedOptions,
      });
    } catch (e) {
      throw Exception('Failed to update user profile: $e');
    }
  }
}
