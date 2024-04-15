import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthAPI {
  static final FirebaseAuth auth = FirebaseAuth.instance;
  Stream<User?> getUser() {
    return auth.authStateChanges();
  }
}
