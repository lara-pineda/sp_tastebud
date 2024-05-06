// Abstracts and exposes all the firebase functionalities provided by AuthService, possibly serving additional
// data-related functionalities or as a facade for more complex data operations.

import 'package:firebase_auth/firebase_auth.dart';
import 'auth_service.dart';

class UserRepository {
  final AuthService _authService;

  UserRepository(this._authService);

  // Method to create a user
  Future<User> createUser(String email, String password) async {
    UserCredential userCredential =
        await _authService.createUserWithEmailAndPassword(email, password);
    return userCredential.user!;
  }

  // Method to sign in a user
  Future<User> signIn(String email, String password) async {
    UserCredential userCredential =
        await _authService.signInWithEmailAndPassword(email, password);
    return userCredential.user!;
  }

  // Method to sign out a user
  Future<void> signOut() async {
    await _authService.signOut();
  }

  // Method to send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    await _authService.sendPasswordResetEmail(email);
  }

  // Method to fetch user data upon logging in
  Future<void> fetchUserDetails(String email) async {
    await _authService.sendPasswordResetEmail(email);
  }

  // Method to fetch the current user
  User? getCurrentUser() {
    return _authService.currentUser();
  }

  // Stream to listen to user authentication state changes
  Stream<User?> get user => _authService.authStateChanges;
}
