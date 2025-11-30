import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:to_do/core/constants/app_config.dart';
import 'package:to_do/core/services/biometric_auth_service.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  late final GoogleSignIn _googleSignIn;
  final FacebookAuth _facebookAuth = FacebookAuth.instance;
  final BiometricAuthService _biometricService = BiometricAuthService();

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

      await _biometricService.saveCredentials(
        email: email,
        password: password,
      );
      await _biometricService.saveAuthMethod(AuthMethod.email);
      await _biometricService.saveLastUserEmail(email);
      await _biometricService.saveLastUserUid(userCredential.user!.uid);

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

      final authEventFuture = _googleSignIn.authenticationEvents.first;


      await _googleSignIn.authenticate();


      final event = await authEventFuture;

      final GoogleSignInAccount? googleUser = switch (event) {
        GoogleSignInAuthenticationEventSignIn() => event.user,
        GoogleSignInAuthenticationEventSignOut() => null,
      };

      if (googleUser == null) {
        throw 'Google sign-in was cancelled.';
      }

      final headers = await googleUser.authorizationClient.authorizationHeaders([
        'email',
        'profile',
      ]);

      if (headers == null) {
        throw 'Failed to get authorization headers.';
      }

      final accessToken = headers['Authorization']?.replaceFirst('Bearer ', '');

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;


      final credential = GoogleAuthProvider.credential(
        accessToken: accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);

      if (userCredential.user?.email != null) {
        await _biometricService.saveLastUserEmail(userCredential.user!.email!);
        await _biometricService.saveAuthMethod(AuthMethod.google);
        await _biometricService.saveLastUserUid(userCredential.user!.uid);
      }

      return userCredential;
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
      final LoginResult result = await _facebookAuth.login(
        permissions: ['email', 'public_profile'],
      );

      log('Facebook login status: ${result.status}');

      if (result.status == LoginStatus.success) {
        final AccessToken? accessToken = result.accessToken;

        if (accessToken == null) {
          throw 'Failed to get Facebook access token.';
        }

        log('Facebook access token obtained');

        final OAuthCredential credential =
        FacebookAuthProvider.credential(accessToken.tokenString);

        final userCredential = await _auth.signInWithCredential(credential);

        if (userCredential.user?.email != null) {
          await _biometricService.saveLastUserEmail(userCredential.user!.email!);
          await _biometricService.saveAuthMethod(AuthMethod.facebook);
          await _biometricService.saveLastUserUid(userCredential.user!.uid);
        }

        return userCredential;
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

  Future<void> resetPassword({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        throw 'The email address is not valid.';
      } else if (e.code == 'user-not-found') {
        throw 'No user found for that email.';
      } else if (e.code == 'too-many-requests') {
        throw 'Too many attempts. Please try again later.';
      }
      throw e.message ?? 'Failed to send password reset email';
    } catch (e) {
      throw 'An unexpected error occurred while sending reset email';
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<UserCredential> signInWithBiometric() async {
    try {
      final lastUserData = await _biometricService.getLastUserData();
      final email = lastUserData['email'];
      final uid = lastUserData['uid'];
      final authMethodName = lastUserData['authMethod'];

      if (email == null || uid == null) {
        throw 'No user has signed in before';
      }

      final authMethod = authMethodName != null
          ? AuthMethod.values.firstWhere(
              (e) => e.name == authMethodName,
              orElse: () => AuthMethod.email,
            )
          : AuthMethod.email;

      UserCredential userCredential;

      switch (authMethod) {

        case AuthMethod.email:

          final credentials = await _biometricService.getCredentials();
          if (credentials == null) {
            throw 'Stored credentials not found';
          }
          userCredential = await signIn(
            email: credentials['email']!,
            password: credentials['password']!,
          );
          break;

        case AuthMethod.google:

          try {

            final authEventFuture = _googleSignIn.authenticationEvents.first;

            await _googleSignIn.authenticate();

            final event = await authEventFuture;

            final GoogleSignInAccount? googleUser = switch (event) {
              GoogleSignInAuthenticationEventSignIn() => event.user,
              GoogleSignInAuthenticationEventSignOut() => null,
            };

            if (googleUser == null) {
              throw 'Google sign-in was cancelled.';
            }

            final headers = await googleUser.authorizationClient.authorizationHeaders([
              'email',
              'profile',
            ]);

            if (headers == null) {
              throw 'Failed to get authorization headers.';
            }

            final accessToken = headers['Authorization']?.replaceFirst('Bearer ', '');
            final GoogleSignInAuthentication googleAuth = googleUser.authentication;

            final credential = GoogleAuthProvider.credential(
              accessToken: accessToken,
              idToken: googleAuth.idToken,
            );

            userCredential = await _auth.signInWithCredential(credential);
          } catch (e) {
            log('Google authentication failed: $e');
            throw 'Failed to sign in with Google. ${e.toString()}';
          }
          break;

        case AuthMethod.facebook:

          try {
            final AccessToken? accessToken = await _facebookAuth.accessToken;

            if (accessToken == null) {
              throw 'Facebook session expired. Please sign in manually.';
            }

            final OAuthCredential credential =
                FacebookAuthProvider.credential(accessToken.tokenString);

            userCredential = await _auth.signInWithCredential(credential);
          } catch (e) {
            log('Facebook silent sign-in failed: $e');
            throw 'Session expired. Please sign in manually with Facebook.';
          }
          break;
      }

      if (userCredential.user?.uid != uid) {
        await signOut();
        throw 'Signed in user does not match the last user';
      }

      return userCredential;
    } catch (e) {
      log('Error during biometric sign-in: $e');
      rethrow;
    }
  }

  String _errorMessageFromSignInException(GoogleSignInException e) {
    return switch (e.code) {
      GoogleSignInExceptionCode.canceled => 'Sign in canceled',
      _ => 'GoogleSignInException ${e.code}: ${e.description}',
    };
  }
}