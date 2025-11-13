import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';

import '../../../../../core/services/auth_service.dart';
import '../../../../../core/services/biometric_auth_service.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthService _authService;
  final BiometricAuthService _biometricService = BiometricAuthService();

  String _username = '';
  String _password = '';
  bool _isLoading = false;
  bool _isPasswordVisible = false;
  bool _biometricAvailable = false;
  bool _biometricEnabled = false;

  LoginBloc({required AuthService authService})
      : _authService = authService,
        super(LoginInitial()) {
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

    // ADD: Google Sign In Handler
    on<GoogleSignInRequested>((event, emit) async {
      await _handleGoogleSignIn(emit);
    });

    // ADD: Facebook Sign In Handler
    on<FacebookSignInRequested>((event, emit) async {
      await _handleFacebookSignIn(emit);
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
      final enabled = await _biometricService.isBiometricEnabled();

      _biometricAvailable = available;
      _biometricEnabled = enabled;

      // Show fingerprint only if both available AND enabled in settings
      if (available && enabled) {
        emit(BiometricAvailable());
      } else {
        emit(BiometricNotAvailable());
      }
    } catch (e) {
      _biometricAvailable = false;
      _biometricEnabled = false;
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
      // First, check if there is a last user
      final hasLastUser = await _biometricService.hasLastUser();
      
      if (!hasLastUser) {
        _isLoading = false;
        emit(LoginNotLoading());
        emit(LoginErrorState('No user has signed in before. Please sign in manually first.'));
        return;
      }

      // If there is a last user, prompt for biometric authentication
      final authenticated = await LocalAuthentication().authenticate(
        localizedReason: 'Please authenticate to access your account',
        persistAcrossBackgrounding: false,
        authMessages: const <AuthMessages>[
          AndroidAuthMessages(
            signInTitle: 'Biometric authentication required',
            cancelButton: 'Cancel',
          ),
        ],
      );

      if (authenticated) {
        // If biometric authentication successful, sign in with the last user
        try {
          await _authService.signInWithBiometric();
          _isLoading = false;
          emit(LoginNotLoading());
          emit(LoginSuccessState());
        } catch (e) {
          _isLoading = false;
          emit(LoginNotLoading());
          emit(LoginErrorState('Failed to sign in: ${e.toString()}'));
        }
      } else {
        _isLoading = false;
        emit(LoginNotLoading());
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
      // CHANGE: Use Firebase sign in instead of mock delay
      await _authService.signIn(
        email: event.username,
        password: event.password,
      );

      _isLoading = false;
      emit(LoginNotLoading());
      emit(LoginSuccessState());
    } catch (e) {
      _isLoading = false;
      emit(LoginNotLoading());
      emit(LoginErrorState(e.toString()));
    }
  }

  // ADD: Google Sign In Handler
  Future<void> _handleGoogleSignIn(Emitter<LoginState> emit) async {
    emit(LoginErrorCleared());
    emit(LoginLoading());
    _isLoading = true;

    try {
      await _authService.continueWithGoogle();

      _isLoading = false;
      emit(LoginNotLoading());
      emit(LoginSuccessState());
    } catch (e) {
      _isLoading = false;
      emit(LoginNotLoading());
      emit(LoginErrorState(e.toString()));
    }
  }

  // ADD: Facebook Sign In Handler
  Future<void> _handleFacebookSignIn(Emitter<LoginState> emit) async {
    emit(LoginErrorCleared());
    emit(LoginLoading());
    _isLoading = true;

    try {
      await _authService.continueWithFacebook();

      _isLoading = false;
      emit(LoginNotLoading());
      emit(LoginSuccessState());
    } catch (e) {
      _isLoading = false;
      emit(LoginNotLoading());
      emit(LoginErrorState(e.toString()));
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

  bool get biometricEnabled => _biometricEnabled;
}
