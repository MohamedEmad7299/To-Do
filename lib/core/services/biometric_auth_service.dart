
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

enum AuthMethod { email, google, facebook }

class BiometricAuthService {
  final LocalAuthentication _localAuth = LocalAuthentication();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  static const String _biometricEnabledKey = 'biometric_enabled';
  static const String _lastUserEmailKey = 'last_user_email';
  static const String _authMethodKey = 'auth_method';
  static const String _userPasswordKey = 'user_password';
  static const String _lastUserUidKey = 'last_user_uid';

  // Check if device supports biometric authentication
  Future<bool> isBiometricAvailable() async {
    try {
      final bool canAuthenticateWithBiometrics = await _localAuth.canCheckBiometrics;
      final bool canAuthenticate = canAuthenticateWithBiometrics || await _localAuth.isDeviceSupported();
      return canAuthenticate;
    } catch (e) {
      print('Error checking biometric availability: $e');
      return false;
    }
  }

  // Get list of available biometric types
  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _localAuth.getAvailableBiometrics();
    } catch (e) {
      print('Error getting available biometrics: $e');
      return [];
    }
  }

  // Authenticate with biometrics
  Future<bool> authenticate({
    String reason = 'Please authenticate to access your account',
  }) async {
    try {
      final bool didAuthenticate = await _localAuth.authenticate(
        localizedReason: reason,
      );
      return didAuthenticate;
    } catch (e) {
      print('Error during biometric authentication: $e');
      return false;
    }
  }

  // Check if biometric authentication is enabled in settings
  Future<bool> isBiometricEnabled() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_biometricEnabledKey) ?? false;
    } catch (e) {
      print('Error checking if biometric is enabled: $e');
      return false;
    }
  }

  // Enable/disable biometric authentication
  Future<void> setBiometricEnabled(bool enabled) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_biometricEnabledKey, enabled);
    } catch (e) {
      print('Error setting biometric enabled: $e');
    }
  }

  // Save last authenticated user email
  Future<void> saveLastUserEmail(String email) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_lastUserEmailKey, email);
    } catch (e) {
      print('Error saving last user email: $e');
    }
  }

  // Get last authenticated user email
  Future<String?> getLastUserEmail() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_lastUserEmailKey);
    } catch (e) {
      print('Error getting last user email: $e');
      return null;
    }
  }

  // Clear last user email (called on logout)
  Future<void> clearLastUserEmail() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_lastUserEmailKey);
    } catch (e) {
      print('Error clearing last user email: $e');
    }
  }

  // Save authentication method type
  Future<void> saveAuthMethod(AuthMethod method) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_authMethodKey, method.name);
    } catch (e) {
      print('Error saving auth method: $e');
    }
  }

  // Get authentication method type
  Future<AuthMethod?> getAuthMethod() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final methodName = prefs.getString(_authMethodKey);
      if (methodName == null) return null;

      return AuthMethod.values.firstWhere(
        (e) => e.name == methodName,
        orElse: () => AuthMethod.email,
      );
    } catch (e) {
      print('Error getting auth method: $e');
      return null;
    }
  }

  // Save user credentials securely (only for email/password auth)
  Future<void> saveCredentials({
    required String email,
    required String password,
  }) async {
    try {
      await _secureStorage.write(key: _lastUserEmailKey, value: email);
      await _secureStorage.write(key: _userPasswordKey, value: password);
    } catch (e) {
      print('Error saving credentials: $e');
    }
  }

  // Get saved credentials
  Future<Map<String, String>?> getCredentials() async {
    try {
      final email = await _secureStorage.read(key: _lastUserEmailKey);
      final password = await _secureStorage.read(key: _userPasswordKey);

      if (email != null && password != null) {
        return {'email': email, 'password': password};
      }
      return null;
    } catch (e) {
      print('Error getting credentials: $e');
      return null;
    }
  }

  // Clear all authentication data
  Future<void> clearAuthData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_lastUserEmailKey);
      await prefs.remove(_authMethodKey);
      await _secureStorage.delete(key: _lastUserEmailKey);
      await _secureStorage.delete(key: _userPasswordKey);
    } catch (e) {
      print('Error clearing auth data: $e');
    }
  }

  // Check if user should be prompted for biometric authentication
  Future<bool> shouldPromptBiometric() async {
    final isAvailable = await isBiometricAvailable();
    final isEnabled = await isBiometricEnabled();
    final lastUserEmail = await getLastUserEmail();

    return isAvailable && isEnabled && lastUserEmail != null;
  }

  // Check if a user has previously signed in
  Future<bool> hasLastUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lastUserEmail = prefs.getString(_lastUserEmailKey);
      return lastUserEmail != null && lastUserEmail.isNotEmpty;
    } catch (e) {
      print('Error checking last user: $e');
      return false;
    }
  }

  // Get last user data for re-authentication
  Future<Map<String, String?>> getLastUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString(_lastUserEmailKey);
      final authMethodName = prefs.getString(_authMethodKey);
      final uid = prefs.getString(_lastUserUidKey);

      if (email == null) {
        throw Exception('No user has signed in before');
      }

      return {
        'email': email,
        'authMethod': authMethodName,
        'uid': uid,
      };
    } catch (e) {
      print('Error getting last user data: $e');
      rethrow;
    }
  }

  // Save last user UID
  Future<void> saveLastUserUid(String uid) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_lastUserUidKey, uid);
    } catch (e) {
      print('Error saving last user UID: $e');
    }
  }

  // Get last user UID
  Future<String?> getLastUserUid() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_lastUserUidKey);
    } catch (e) {
      print('Error getting last user UID: $e');
      return null;
    }
  }
}
