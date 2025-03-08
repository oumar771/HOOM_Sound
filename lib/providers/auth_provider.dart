// lib/providers/auth_provider.dart
import 'package:flutter/material.dart';
import '../repositories/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();
  bool isLoading = false;
  String? errorMessage;
  DateTime? lastSignInAttempt;
  DateTime? lastSignOutAttempt;
  final List<String> _debugLogs = [];

  List<String> get debugLogs => List.unmodifiable(_debugLogs);

  void _addLog(String log) {
    final entry = '${DateTime.now().toIso8601String()} - $log';
    _debugLogs.add(entry);
    print(entry);
  }

  Future<void> signInWithSpotify() async {
    _addLog("SignInWithSpotify: start");
    isLoading = true;
    errorMessage = null;
    lastSignInAttempt = DateTime.now();
    notifyListeners();

    try {
      _addLog("Attempting sign in...");
      await _authRepository.signInWithSpotify();
      _addLog("Sign in succeeded");
    } catch (e) {
      errorMessage = e.toString();
      _addLog("Sign in failed: $errorMessage");
    } finally {
      isLoading = false;
      _addLog("SignInWithSpotify: end");
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    _addLog("SignOut: start");
    lastSignOutAttempt = DateTime.now();
    notifyListeners();

    try {
      _addLog("Attempting sign out...");
      await _authRepository.signOut();
      _addLog("Sign out succeeded");
    } catch (e) {
      errorMessage = e.toString();
      _addLog("Sign out failed: $errorMessage");
    } finally {
      _addLog("SignOut: end");
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>?> fetchUserProfile() async {
    _addLog("Fetching user profile...");
    try {
      final data = await _authRepository.fetchUserProfile();
      return data;
    } catch (e) {
      _addLog("Error fetching user profile: $e");
      throw Exception("Unable to fetch user profile.");
    }
  }

  Future<bool> isUserLoggedIn() async {
    _addLog("Checking user login status...");
    try {
      final isLoggedIn = await _authRepository.isUserLoggedIn();
      _addLog("User logged in: $isLoggedIn");
      return isLoggedIn;
    } catch (e) {
      _addLog("Error checking login status: $e");
      return false;
    }
  }

  String get authStatusSummary {
    final buffer = StringBuffer();
    buffer.writeln("Auth Status:");
    for (final log in _debugLogs) {
      buffer.writeln(log);
    }
    return buffer.toString();
  }
}
