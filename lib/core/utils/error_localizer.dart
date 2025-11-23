import 'package:flutter/material.dart';
import 'package:to_do/l10n/app_localizations.dart';

class ErrorLocalizer {
  static String localizeError(BuildContext context, String error) {
    final l10n = AppLocalizations.of(context)!;

    // Biometric errors
    if (error.contains('Authentication Cancelled') ||
        error.contains('Authentication cancelled')) {
      return l10n.authenticationCancelled;
    }
    if (error.contains('Biometric authentication not available')) {
      return l10n.biometricNotAvailable;
    }
    if (error.contains('Failed to check biometric availability')) {
      return l10n.biometricCheckFailed;
    }
    if (error.contains('No user has signed in before')) {
      return l10n.noUserSignedInBefore;
    }
    if (error.contains('Failed to sign in')) {
      return '${l10n.failedToSignIn}: ${_extractErrorDetail(error)}';
    }
    if (error.contains('Authentication failed')) {
      return l10n.authenticationFailed;
    }

    // Firebase Auth errors
    if (error.contains('weak-password') || error.contains('password is too weak')) {
      return l10n.weakPassword;
    }
    if (error.contains('email-already-in-use') || error.contains('account already exists')) {
      return l10n.emailAlreadyInUse;
    }
    if (error.contains('invalid-email') || error.contains('email address is not valid')) {
      return l10n.invalidEmail;
    }
    if (error.contains('user-not-found') || error.contains('No user found')) {
      return l10n.userNotFound;
    }
    if (error.contains('wrong-password') || error.contains('Wrong password')) {
      return l10n.wrongPassword;
    }
    if (error.contains('too-many-requests') || error.contains('Too many attempts')) {
      return l10n.tooManyAttempts;
    }

    // Google Sign In errors
    if (error.contains('Google sign-in was cancelled')) {
      return l10n.googleSignInCancelled;
    }
    if (error.contains('Error during Google sign-in')) {
      return l10n.googleSignInError;
    }
    if (error.contains('unexpected error occurred during Google sign-in')) {
      return l10n.googleSignInUnexpectedError;
    }

    // Facebook Sign In errors
    if (error.contains('Facebook sign-in was cancelled')) {
      return l10n.facebookSignInCancelled;
    }
    if (error.contains('Facebook sign-in failed')) {
      return l10n.facebookSignInFailed;
    }
    if (error.contains('Error during Facebook sign-in')) {
      return l10n.facebookSignInError;
    }
    if (error.contains('unexpected error occurred during Facebook sign-in')) {
      return l10n.facebookSignInUnexpectedError;
    }

    // Registration errors
    if (error.contains('error occurred during registration')) {
      return l10n.registrationError;
    }

    // Login errors
    if (error.contains('error occurred during login')) {
      return l10n.loginError;
    }

    // Password reset errors
    if (error.contains('Failed to send password reset email')) {
      return l10n.passwordResetFailed;
    }
    if (error.contains('unexpected error occurred while sending reset email')) {
      return l10n.passwordResetUnexpectedError;
    }

    // Default - unexpected error
    if (error.contains('unexpected error')) {
      return l10n.unexpectedError;
    }

    // If no match found, return the original error
    return error;
  }

  static String _extractErrorDetail(String error) {
    // Extract detail after colon if present
    if (error.contains(':')) {
      return error.substring(error.indexOf(':') + 1).trim();
    }
    return '';
  }
}
