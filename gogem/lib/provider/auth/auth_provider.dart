import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../service/auth/firebase_service.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseService _service = FirebaseService();
  User? _user;

  User? get user => _user;

  AuthProvider() {
    _user = _service.currentUser;
    _service.authStateChanges.listen((u) {
      _user = u;
      notifyListeners();
    });
  }

  Future<void> signIn(String email, String password) async {
    _user = await _service.signIn(email, password);
    notifyListeners();
  }

  Future<void> signUp(String email, String password) async {
    _user = await _service.signUp(email, password);
    notifyListeners();
  }

  Future<void> signInWithGoogle() async {
    _user = await _service.signInWithGoogle();
    notifyListeners();
  }

  Future<void> signOut() async {
    await _service.signOut();
    _user = null;
    notifyListeners();
  }
}
