import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {

  
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  String? _error;
  bool _isLoading = false;
  bool _initialCheck = true;

  User? get user => _user;
  String? get error => _error;
  bool get isLoading => _isLoading;
  bool get initialCheck => _initialCheck;

  AuthProvider() {
    _auth.authStateChanges().listen((User? user) {
      _user = user;
      _initialCheck = false;
      notifyListeners();
    });
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    try {
      _setLoading(true);
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      return true;
    } on FirebaseAuthException catch (e) {
      _error = _getErrorMessage(e);
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> signUp(String email, String password) async {
    try {
      _setLoading(true);
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      await cred.user?.sendEmailVerification();
      return true;
    } on FirebaseAuthException catch (e) {
      _error = _getErrorMessage(e);
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  String _getErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email': return 'Invalid email format';
      case 'user-not-found': return 'No account found';
      case 'wrong-password': return 'Incorrect password';
      case 'email-already-in-use': return 'Email already registered';
      case 'weak-password': return 'Use stronger password';
      default: return 'Authentication failed';
    }
  }
  
  Future<void> resetPassword(String email) async {
    try {
      _setLoading(true);
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email.trim());
    } finally {
      _setLoading(false);
    }
  }

  

}