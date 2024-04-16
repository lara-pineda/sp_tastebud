import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  Future<void> saveDietaryPreferences(
      String userId, List<bool> preferences) async {
    try {
      await usersCollection.doc(userId).set({
        'dietaryPreferences': preferences,
      }, SetOptions(merge: true));
    } catch (e) {
      print('Error saving dietary preferences: $e');
      throw e;
    }
  }

  Future<List<bool>> getDietaryPreferences(String userId) async {
    try {
      var doc = await usersCollection.doc(userId).get();
      if (doc.exists) {
        return List<bool>.from(doc['dietaryPreferences']);
      } else {
        // User document doesn't exist, return an empty list or handle as needed
        return [];
      }
    } catch (e) {
      print('Error getting dietary preferences: $e');
      throw e;
    }
  }
}
