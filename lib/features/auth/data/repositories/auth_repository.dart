import 'package:chupachap/features/auth/data/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthRepository {
  final firebase_auth.FirebaseAuth _firebaseAuth =
      firebase_auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Register a new user with email, password, first name, and last name
  Future<String> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    try {
      // Create a new user with the given email and password
      firebase_auth.UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Get the user's UID
      final String uid = userCredential.user?.uid ?? '';

      // Store the user's first name and last name in Firestore
      await _firestore.collection('users').doc(uid).set({
        'email': email,
        'firstName': firstName,
        'lastName': lastName,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Return the email of the newly created user
      return userCredential.user?.email ?? '';
    } on firebase_auth.FirebaseAuthException catch (e) {
      // Specific error handling
      switch (e.code) {
        case 'email-already-in-use':
          throw Exception('The email address is already in use.');
        case 'weak-password':
          throw Exception('The password is too weak.');
        case 'invalid-email':
          throw Exception('The email address is invalid.');
        default:
          throw Exception('Authentication error: ${e.message}');
      }
    } catch (e) {
      throw Exception('An unexpected error occurred during registration: $e');
    }
  }

  // Login an existing user with email and password
  Future<String> login({
    required String email,
    required String password,
  }) async {
    try {
      firebase_auth.UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user?.email ?? '';
    } on firebase_auth.FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          throw Exception('No user found with this email.');
        case 'wrong-password':
          throw Exception('Incorrect password.');
        case 'user-disabled':
          throw Exception('This user account has been disabled.');
        default:
          throw Exception('Login failed: ${e.message}');
      }
    } catch (e) {
      throw Exception('An unexpected error occurred during login: $e');
    }
  }

  // Logout the current user
  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  // Get current user details
  Future<User?> getCurrentUserDetails() async {
    try {
      final firebase_auth.User? currentUser = _firebaseAuth.currentUser;
      if (currentUser != null) {
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(currentUser.uid).get();

        if (userDoc.exists) {
          return User(
              email: userDoc['email'],
              firstName: userDoc['firstName'],
              lastName: userDoc['lastName'],
               profileImage:userDoc['profileImage']);
        }
      }
      return null;
    } catch (e) {
      throw Exception('Error retrieving user details: $e');
    }
  }

  // Check if a user is currently signed in
  bool isUserSignedIn() {
    return _firebaseAuth.currentUser != null;
  }

  // Get current user's UID
  String? getCurrentUserId() {
    return _firebaseAuth.currentUser?.uid;
  }
}
