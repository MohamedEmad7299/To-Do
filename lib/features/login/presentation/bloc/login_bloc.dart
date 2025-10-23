import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_ios/types/auth_messages_ios.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LocalAuthentication _auth;

  LoginBloc({LocalAuthentication? auth})
      : _auth = auth ?? LocalAuthentication(),
        super(const LoginState()) {

    on<CheckBiometricAvailability>((event, emit) async {
      try {
        final available = await _auth.canCheckBiometrics;
        emit(state.copyWith(biometricAvailable: available));
      } catch (e) {
        emit(state.copyWith(
          biometricAvailable: false,
          loginError: 'Failed to check biometric availability',
        ));
      }
    });

    on<BiometricAuthenticationRequested>((event, emit) async {
      if (!state.biometricAvailable) {
        emit(state.copyWith(
          loginError: 'Biometric authentication not available',
        ));
        return;
      }

      emit(state.copyWith(isLoading: true, loginError: null));

      try {
        final authenticated = await _auth.authenticate(
          localizedReason: 'Please authenticate to access your account',
          authMessages: const <AuthMessages>[
            AndroidAuthMessages(
              signInTitle: 'Biometric authentication required',
              cancelButton: 'Cancel',
            ),
            IOSAuthMessages(
              cancelButton: 'Cancel',
            ),
          ],
        );

        if (authenticated) {
          emit(state.copyWith(
            isLoading: false,
            loginSuccess: true,
            loginError: null,
          ));
        } else {
          emit(state.copyWith(
            isLoading: false,
            loginError: 'Authentication failed',
          ));
        }
      } catch (e) {
        emit(state.copyWith(
          isLoading: false,
          loginError: 'Authentication error: ${e.toString()}',
        ));
      }
    });

    on<UsernameChanged>((event, emit) {
      final trimmedUsername = event.username.trim();
      emit(state.copyWith(
        username: trimmedUsername,
      ));
    });

    on<PasswordChanged>((event, emit) {
      emit(state.copyWith(
        password: event.password,
      ));
    });

    on<PasswordVisibilityChanged>((event, emit) {
      emit(state.copyWith(isPasswordVisible: !event.isPasswordVisible));
    });

    on<ValidateFields>((event, emit) {
      final usernameError = _validateUsername(state.username);
      final passwordError = _validatePassword(state.password);
      final isValid = usernameError == null && passwordError == null;

      emit(state.copyWith(
        usernameError: usernameError,
        passwordError: passwordError,
        hasValidated: true,
        isValid: isValid,
      ));
    });

    on<LoginSubmitted>((event, emit) async {
      emit(state.copyWith(isLoading: true));

      try {
        await Future.delayed(const Duration(seconds: 1));

        emit(state.copyWith(
          isLoading: false,
          loginSuccess: true,
        ));
      } catch (e) {
        emit(state.copyWith(
          isLoading: false,
          loginError: 'Login failed. Please check your credentials.',
        ));
      }
    });

    on<ClearUser>((event, emit) {
      emit(state.copyWith(
        username: "",
      ));
    });

    on<ClearPassword>((event, emit) {
      emit(state.copyWith(
        password: "",
      ));
    });
  }

  String? _validateUsername(String username) {
    if (username.isEmpty) {
      return 'Username cannot be empty';
    }

    final emailRegex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(username)) {
      return 'Please enter a valid email address';
    }

    if (username.length > 100) {
      return 'Email is too long (max 100 characters)';
    }

    return null;
  }

  String? _validatePassword(String password) {
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

    return null;
  }
}