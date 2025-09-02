import 'dart:async';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import '../models/user_model.dart';

/// Repository for authentication operations
class AuthRepository {
  static final AuthRepository _instance = AuthRepository._internal();
  factory AuthRepository() => _instance;
  AuthRepository._internal();

  /// Initialize EaseMob SDK
  Future<void> initializeSDK() async {
    EMOptions options = EMOptions.withAppKey(
      "easemob-demo#support",
      autoLogin: false,
      debugMode: true,
      requireAck: true,
      extSettings: {
        ExtSettings.kAppIDForOhOS: "111703463",
      },
    );
    await EMClient.getInstance.init(options);
    await EMClient.getInstance.startCallback();
  }

  /// Login with username and password
  Future<UserModel> login(String username, String password) async {
    try {
      await EMClient.getInstance.loginWithPassword(username, password);
      return UserModel(userId: username, isOnline: true);
    } on EMError catch (e) {
      if (e.code == 200) {
        // Already logged in
        return UserModel(userId: username, isOnline: true);
      }
      throw Exception('Login failed: ${e.description}');
    }
  }

  /// Logout
  Future<void> logout() async {
    try {
      await EMClient.getInstance.logout(true);
    } on EMError catch (e) {
      throw Exception('Logout failed: ${e.description}');
    }
  }

  /// Check if user is logged in
  Future<bool> isLoggedIn() {
    // For now, we'll implement a simple check
    // You may need to implement your own logic here
    return EMClient.getInstance.isConnected();
  }

  /// Get current user
  String? getCurrentUserId() {
    // For now, we'll implement a simple check
    // You may need to implement your own logic here
    return EMClient.getInstance.currentUserId;
  }

  /// Register new account
  Future<void> register(String username, String password) async {
    try {
      await EMClient.getInstance.createAccount(username, password);
    } on EMError catch (e) {
      throw Exception('Registration failed: ${e.description}');
    }
  }
}
