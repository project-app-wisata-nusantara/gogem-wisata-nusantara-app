import 'package:flutter/material.dart';
import '../../service/auth/firebase_service.dart';

class ProfileProvider extends ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();

  String? _displayName;
  String? _email;
  String? _photoUrl;

  String? get displayName => _displayName;
  String? get email => _email;
  String? get photoUrl => _photoUrl;

  Future<void> loadUserData() async {
    final user = _firebaseService.currentUser;
    if (user != null) {
      _displayName = user.displayName ?? 'User';
      _email = user.email ?? 'xxx@gmail.com';
      _photoUrl = user.photoURL; // bisa null kalau belum di-set
    } else {
      _displayName = 'User';
      _email = 'xxx@gmail.com';
      _photoUrl = null;
    }
    notifyListeners();
  }

  Future<void> logout() async {
    await _firebaseService.signOut();
    notifyListeners();
  }
}
