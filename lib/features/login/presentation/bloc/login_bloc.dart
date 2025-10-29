import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_ios/types/auth_messages_ios.dart';

part 'login_event.dart';

part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  // Internal state tracking
  String _username = '';
  String _password = '';
  bool _isLoading = false;
  bool _isPasswordVisible = false;
  bool _biometricAvailable = false;

  LoginBloc({LocalAuthentication? auth}) : super(LoginInitial()) {
    on<CheckBiometricAvailability>((event, emit) async {
      await _checkBiometricAvailability(emit);
    });

    on<BiometricAuthenticationRequested>((event, emit) async {
      await _handleBiometricAuthentication(emit);
    });

    on<PasswordVisibilityChanged>((event, emit) {
      _togglePasswordVisibility(event, emit);
    });

    on<LoginSubmitted>((event, emit) async {
      await _handleLoginSubmission(event, emit);
    });

    on<LoginReset>((event, emit) {
      _resetLogin(emit);
    });

    on<ClearLoginError>((event, emit) {
      emit(LoginErrorCleared());
    });

    on<BiometricAuthenticationCancelled>((event, emit) {
      emit(LoginErrorState('Authentication Cancelled'));
    });

    add(CheckBiometricAvailability());
  }

  Future<void> _checkBiometricAvailability(Emitter<LoginState> emit) async {
    try {
      final available = await LocalAuthentication().canCheckBiometrics;
      _biometricAvailable = available;

      if (available) {
        emit(BiometricAvailable());
      } else {
        emit(BiometricNotAvailable());
      }
    } catch (e) {
      _biometricAvailable = false;
      emit(BiometricNotAvailable());
      emit(LoginErrorState('Failed to check biometric availability'));
    }
  }

  Future<void> _handleBiometricAuthentication(Emitter<LoginState> emit) async {
    if (!_biometricAvailable) {
      emit(LoginErrorState('Biometric authentication not available'));
      return;
    }

    emit(LoginErrorCleared());
    emit(LoginLoading());
    _isLoading = true;

    try {
      final authenticated = await LocalAuthentication().authenticate(
        localizedReason: 'Please authenticate to access your account',
        persistAcrossBackgrounding: false,
        authMessages: const <AuthMessages>[
          AndroidAuthMessages(
            signInTitle: 'Biometric authentication required',
            cancelButton: 'Cancel',
          ),
          IOSAuthMessages(cancelButton: 'Cancel'),
        ],
      );

      _isLoading = false;
      emit(LoginNotLoading());

      if (authenticated) {
        emit(LoginSuccessState());
      } else {
        emit(LoginErrorState('Authentication failed'));
        await LocalAuthentication().stopAuthentication();
      }
    } catch (e) {
      debugPrint(e.toString());
      _isLoading = false;
      emit(LoginNotLoading());
      emit(LoginErrorState('Authentication cancelled'));
    }
  }

  void _togglePasswordVisibility(
    PasswordVisibilityChanged event,
    Emitter<LoginState> emit,
  ) {
    _isPasswordVisible = !event.isPasswordVisible;

    if (_isPasswordVisible) {
      emit(PasswordVisible());
    } else {
      emit(PasswordHidden());
    }
  }

  Future<void> _handleLoginSubmission(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    _username = event.username;
    _password = event.password;
    _isLoading = true;

    emit(UsernameChanged(_username));
    emit(PasswordChanged(_password));
    emit(LoginLoading());

    try {
      await Future.delayed(const Duration(seconds: 100));

      _isLoading = false;
      emit(LoginNotLoading());
      emit(LoginSuccessState());
    } catch (e) {
      _isLoading = false;
      emit(LoginNotLoading());
      emit(LoginErrorState('Login failed. Please check your credentials.'));
    }
  }

  void _resetLogin(Emitter<LoginState> emit) {
    _username = '';
    _password = '';
    _isLoading = false;
    _isPasswordVisible = false;

    emit(LoginInitial());
  }

  // Getters for internal state
  bool get isLoading => _isLoading;

  bool get isPasswordVisible => _isPasswordVisible;

  bool get biometricAvailable => _biometricAvailable;
}
