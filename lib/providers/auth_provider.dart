import 'dart:developer';

import 'package:ayurved_care/models/user_model.dart';
import 'package:ayurved_care/services/api_services.dart';
import 'package:ayurved_care/services/storage_service.dart';
import 'package:flutter/foundation.dart';

class AuthProvider with ChangeNotifier {
  UserModel? _user;
  bool _isLoading = true;
  bool _isAuthenticating = false;
  String _errorMessage = '';

  // Getters
  UserModel? get user => _user;
  bool get isAuthenticated => _user != null;
  bool get isLoading => _isLoading;
  bool get isAuthenticating => _isAuthenticating;
  String get errorMessage => _errorMessage;
  String? get token => _user?.token;

  AuthProvider() {
    _initializeAuth();
  }

  // Initialize authentication state from storage
  Future<void> _initializeAuth() async {
    try {
      _isLoading = true;
      notifyListeners();

      final savedUser = await StorageService.getUser();
      if (savedUser != null) {
        _user = savedUser;
      }
    } catch (e) {
      log('Error initializing auth: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Login method
  Future<bool> login({
    required String username,
    required String password,
  }) async {
    try {
      _isAuthenticating = true;
      _errorMessage = '';
      notifyListeners();

      // Validate input
      if (username.trim().isEmpty || password.trim().isEmpty) {
        _errorMessage = 'Username and password are required';
        return false;
      }

      final result = await ApiServices.login(
        username: username.trim(),
        password: password.trim(),
      );

      if (result['success']) {
        // Create user object with token from response
        final userData = result['data'];
        _user = UserModel(
          token: userData['token'] ?? '',
          username: username.trim(),
        );

        // Save user data to storage
        await StorageService.saveUser(_user!);
        
        _errorMessage = '';
        return true;
      } else {
        _errorMessage = result['message'];
        return false;
      }
    } catch (e) {
      _errorMessage = 'An unexpected error occurred: ${e.toString()}';
      return false;
    } finally {
      _isAuthenticating = false;
      notifyListeners();
    }
  }

  // Logout method
  Future<void> logout() async {
    try {
      await StorageService.clearUser();
      _user = null;
      _errorMessage = '';
      notifyListeners();
    } catch (e) {
      print('Error during logout: $e');
    }
  }

  // Clear error message
  void clearError() {
    _errorMessage = '';
    notifyListeners();
  }

  bool isTokenValid() {
    return _user != null && _user!.token.isNotEmpty;
  }
}