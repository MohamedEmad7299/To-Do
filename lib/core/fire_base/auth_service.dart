
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:to_do/core/constants/AppConfig.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  late final GoogleSignIn _googleSignIn;
  final FacebookAuth _facebookAuth = FacebookAuth.instance;

  AuthService() {

    _googleSignIn = GoogleSignIn.instance;
    _googleSignIn.initialize(
      serverClientId: AppConfig.googleWebClientId,
    );
  }

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<UserCredential> signUp({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw 'The password is too weak.';
      } else if (e.code == 'email-already-in-use') {
        throw 'An account already exists for that email.';
      } else if (e.code == 'invalid-email') {
        throw 'The email address is not valid.';
      }
      throw e.message ?? 'An error occurred during registration';
    } catch (e) {
      throw 'An unexpected error occurred';
    }
  }

  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        throw 'Wrong password provided.';
      } else if (e.code == 'invalid-email') {
        throw 'The email address is not valid.';
      }
      throw e.message ?? 'An error occurred during login';
    } catch (e) {
      throw 'An unexpected error occurred';
    }
  }

  Future<UserCredential> continueWithGoogle() async {
    try {
      // Start listening to authentication events BEFORE calling authenticate
      final authEventFuture = _googleSignIn.authenticationEvents.first;

      // Trigger authentication
      await _googleSignIn.authenticate();

      // Wait for the authentication event
      final event = await authEventFuture;

      final GoogleSignInAccount? googleUser = switch (event) {
        GoogleSignInAuthenticationEventSignIn() => event.user,
        GoogleSignInAuthenticationEventSignOut() => null,
      };

      if (googleUser == null) {
        throw 'Google sign-in was cancelled.';
      }

      // Get authorization headers with required scopes
      final headers = await googleUser.authorizationClient.authorizationHeaders([
        'email',
        'profile',
      ]);

      if (headers == null) {
        throw 'Failed to get authorization headers.';
      }

      final accessToken = headers['Authorization']?.replaceFirst('Bearer ', '');

      // Get authentication details for ID token
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      // Create credential
      final credential = GoogleAuthProvider.credential(
        accessToken: accessToken,
        idToken: googleAuth.idToken,
      );

      return await _auth.signInWithCredential(credential);
    } on GoogleSignInException catch (e) {
      throw _errorMessageFromSignInException(e);
    } on FirebaseAuthException catch (e) {
      throw e.message ?? 'Error during Google sign-in.';
    } catch (e) {
      throw 'An unexpected error occurred during Google sign-in: $e';
    }
  }

  Future<UserCredential> continueWithFacebook() async {
    try {
      // Trigger the Facebook authentication flow
      final LoginResult result = await _facebookAuth.login(
        permissions: ['email', 'public_profile'],
      );

      log('Facebook login status: ${result.status}');

      // Check the result status
      if (result.status == LoginStatus.success) {
        final AccessToken? accessToken = result.accessToken;

        if (accessToken == null) {
          throw 'Failed to get Facebook access token.';
        }

        log('Facebook access token obtained');

        final OAuthCredential credential =
        FacebookAuthProvider.credential(accessToken.tokenString);

        return await _auth.signInWithCredential(credential);
      } else if (result.status == LoginStatus.cancelled) {
        throw 'Facebook sign-in was cancelled.';
      } else {
        log('Facebook login failed: ${result.message}');
        throw 'Facebook sign-in failed: ${result.message ?? "Unknown error"}';
      }
    } on FirebaseAuthException catch (e) {
      log('FirebaseAuthException: ${e.code} - ${e.message}');
      throw e.message ?? 'Error during Facebook sign-in.';
    } catch (e) {
      log('Facebook sign-in error: $e');
      throw 'An unexpected error occurred during Facebook sign-in: $e';
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.disconnect();
    await _facebookAuth.logOut();
  }

  String _errorMessageFromSignInException(GoogleSignInException e) {
    return switch (e.code) {
      GoogleSignInExceptionCode.canceled => 'Sign in canceled',
      _ => 'GoogleSignInException ${e.code}: ${e.description}',
    };
  }
}