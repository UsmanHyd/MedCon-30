import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:medcon30/theme/theme_provider.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Sign up with email & password
  Future<UserCredential?> signUp(String email, String password,
      String phoneNumber, String role, String name) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Store additional user data in Firestore with role
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'email': email,
        'phoneNumber': phoneNumber,
        'name': name,
        'role': role,
        'createdAt': FieldValue.serverTimestamp(),
      });

      return userCredential;
    } catch (e) {
      rethrow;
    }
  }

  // Sign in with email & password
  Future<UserCredential?> signIn(
      String email, String password, String expectedRole) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Verify user's role
      final userDoc = await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();
      if (!userDoc.exists) {
        throw Exception('User document not found');
      }

      final userData = userDoc.data();
      if (userData == null || userData['role'] != expectedRole) {
        // Sign out the user if role doesn't match
        await _auth.signOut();
        throw Exception('Invalid role for this login');
      }

      return userCredential;
    } catch (e) {
      rethrow;
    }
  }

  // Get user's role
  Future<String?> getUserRole(String uid) async {
    try {
      final userDoc = await _firestore.collection('users').doc(uid).get();
      if (!userDoc.exists) {
        return null;
      }
      final data = userDoc.data();
      if (data == null) {
        return null;
      }
      return data['role'] as String?;
    } catch (e) {
      print('Error getting user role: $e');
      return null;
    }
  }

  // Get user's phone number
  Future<String?> getUserPhoneNumber(String uid) async {
    try {
      final userDoc = await _firestore.collection('users').doc(uid).get();
      if (!userDoc.exists) {
        return null;
      }
      final data = userDoc.data();
      if (data == null) {
        return null;
      }
      return data['phoneNumber'] as String?;
    } catch (e) {
      print('Error getting phone number: $e');
      return null;
    }
  }

  // Google sign in
  Future<UserCredential?> signInWithGoogle(String expectedRole) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return null; // User cancelled

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);

      // Check if user exists in Firestore
      final userDoc = await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      if (!userDoc.exists) {
        // First time Google sign in - create user document with role
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'email': googleUser.email,
          'role': expectedRole,
          'createdAt': FieldValue.serverTimestamp(),
        });
      } else {
        // Verify existing user's role
        final userData = userDoc.data();
        if (userData == null || userData['role'] != expectedRole) {
          await _auth.signOut();
          throw Exception('Invalid role for this login');
        }
      }

      return userCredential;
    } catch (e) {
      rethrow;
    }
  }

  // Sign out
  Future<void> signOut(BuildContext context) async {
    try {
      await _auth.signOut();
      await GoogleSignIn().signOut();
      // Reset theme to light mode
      Provider.of<ThemeProvider>(context, listen: false).resetToLightMode();
    } catch (e) {
      rethrow;
    }
  }

  // Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      rethrow;
    }
  }
}
