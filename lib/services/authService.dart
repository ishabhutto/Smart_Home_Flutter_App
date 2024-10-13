import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Sign Up with email, password, and username
  Future<User?> signUp(String email, String password, String username) async {
    try {
      // Create user with email and password
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Save additional user information to Firestore
      await _firestore.collection('users').doc(userCredential.user?.uid).set({
        'username': username,
        'email': email,
        // You can add more fields here if needed
      });

      return userCredential.user;
    } catch (e) {
      if (kDebugMode) {
        print("Sign-up failed: $e");
      }
      return null;
    }
  }

  // Log In with email and password
  Future<Map<String, dynamic>?> logIn(String email, String password) async {
    try {
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Fetch additional user information from Firestore
      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(userCredential.user?.uid)
          .get();

      // Return user data including username
      return userDoc.data()
          as Map<String, dynamic>?; // Return user data as a map
    } catch (e) {
      if (kDebugMode) {
        print("Log-in failed: $e");
      }
      return null;
    }
  }
}
