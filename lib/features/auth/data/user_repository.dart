// Abstracts and exposes all the firebase functionalities provided by AuthService, possibly serving additional
// data-related functionalities or as a facade for more complex data operations.

import 'package:firebase_auth/firebase_auth.dart';
import 'auth_service.dart';

class UserRepository {
  final AuthService _authService;

  UserRepository(this._authService);

  // Stream to listen to user authentication state changes
  Stream<User?> get user => _authService.authStateChanges;

  // Method to create a user
  Future<User> createUser(String email, String password) async {
    try {
      UserCredential userCredential =
          await _authService.createUserWithEmailAndPassword(email, password);
      return userCredential.user!;
    } catch (e) {
      rethrow; // Rethrow the exception to be handled by BLoC
    }
  }

  // Method to sign in a user
  Future<User> signIn(String email, String password) async {
    try {
      UserCredential userCredential =
          await _authService.signInWithEmailAndPassword(email, password);
      return userCredential.user!;
    } catch (e) {
      rethrow; // Rethrow the exception to be handled by BLoC
    }
  }

  // Method to sign out a user
  Future<void> signOut() async {
    try {
      await _authService.signOut();
    } catch (e) {
      rethrow;
    }
  }

  // Method to send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _authService.sendPasswordResetEmail(email);
    } catch (e) {
      rethrow;
    }
  }

  // Method to fetch user data upon logging in
  Future<void> fetchUserDetails(String email) async {
    try {
      await _authService.sendPasswordResetEmail(email);
    } catch (e) {
      rethrow;
    }
  }

  // Method to fetch the current user
  User? getCurrentUser() {
    try {
      return _authService.currentUser();
    } catch (e) {
      rethrow;
    }
  }
}
