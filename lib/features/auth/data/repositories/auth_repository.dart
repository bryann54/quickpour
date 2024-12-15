import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Register a new user with email and password
  Future<String> register(String email, String password) async {
    try {
      // Create a new user with the given email and password
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Return the email of the newly created user (or user ID if needed)
      return userCredential.user?.email ??
          ''; // Return user email or other user data if required
    } on FirebaseAuthException catch (e) {
      // Handle specific errors
      if (e.code == 'email-already-in-use') {
        throw Exception('The email address is already in use.');
      } else if (e.code == 'weak-password') {
        throw Exception('The password is too weak.');
      } else {
        throw Exception('An unknown error occurred: ${e.message}');
      }
    }
  }

  // Login an existing user with email and password
  Future<String> login(String email, String password) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user?.email ?? '';
    } on FirebaseAuthException catch (e) {
      throw Exception('Login failed: ${e.message}');
    }
  }

  // Logout the current user
  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }
}
