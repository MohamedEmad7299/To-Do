
class ValidatorHelper {


  /// Validates a username (email address)
  /// Returns null if valid, or an error message if invalid
  static String? validateEmailAddress(String? username) {

    if (username != null){

      username = username.trim();

      if (username.isEmpty) {
        return 'Username cannot be empty';
      }

      final emailRegex = RegExp(
        r'^[\w\-.]+@([\w\-]+\.)+[\w\-]{2,4}$',
        caseSensitive: false,
      );

      if (!emailRegex.hasMatch(username)) {
        return 'Please enter a valid email address';
      }

      if (username.length > 100) {
        return 'Email is too long (max 100 characters)';
      }
    }

    return null;
  }

  static String? validatePassword(String? password) {

    if (password != null){

      if (password.isEmpty) {
        return 'Password cannot be empty';
      }

      if (password.length < 8) {
        return 'Password must be at least 8 characters long';
      }

      if (!RegExp(r'[A-Z]').hasMatch(password)) {
        return 'Password must contain at least one uppercase letter';
      }

      if (!RegExp(r'[a-z]').hasMatch(password)) {
        return 'Password must contain at least one lowercase letter';
      }

      if (!RegExp(r'[0-9]').hasMatch(password)) {
        return 'Password must contain at least one digit';
      }

      if (!RegExp(r'[!@#$%^&*(),.?":{}|<>_\-\[\]\\/]').hasMatch(password)) {
        return 'Password must contain at least one special character';
      }

      if (password.contains(' ')) {
        return 'Password cannot contain spaces';
      }

      if (password.length > 64) {
        return 'Password is too long (max 64 characters)';
      }

    }

    return null;
  }
}