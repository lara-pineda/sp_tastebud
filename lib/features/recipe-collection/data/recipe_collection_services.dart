import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RecipeCollectionService {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth;

  RecipeCollectionService(this._firestore, this._firebaseAuth);

  Future<List<dynamic>> fetchSavedRecipes() async {
    User? user = _firebaseAuth.currentUser;
    if (user == null) throw Exception("User not logged in");
    var collection =
        _firestore.collection('users').doc(user.uid).collection('savedRecipes');
    var snapshot = await collection.get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<List<dynamic>> fetchRejectedRecipes() async {
    User? user = _firebaseAuth.currentUser;
    if (user == null) throw Exception("User not logged in");
    var collection = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('rejectedRecipes');
    var snapshot = await collection.get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }
}
