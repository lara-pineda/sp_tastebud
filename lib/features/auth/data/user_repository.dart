// Abstracting the data access to Firebase through AuthService, possibly serving additional
// data-related functionalities or as a facade for more complex data operations.

import 'package:firebase_auth/firebase_auth.dart';
import 'auth_service.dart';

class UserRepository {
  final AuthService _authService;

  UserRepository(this._authService);

  Future<User> createUser(String email, String password) async {
    UserCredential userCredential =
        await _authService.createUserWithEmailAndPassword(email, password);
    return userCredential.user!;
  }

  Stream<User?> get user => _authService.authStateChanges;
}
