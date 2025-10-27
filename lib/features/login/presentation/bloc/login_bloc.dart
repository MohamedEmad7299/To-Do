
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
      emit(const LoginState());
    });

    on<ClearLoginError>((event, emit) {
      emit(state.copyWith(loginError: null));
    });


    add(CheckBiometricAvailability());
  }

  Future<void> _checkBiometricAvailability(Emitter<LoginState> emit) async {
    try {
      final available = await _auth.canCheckBiometrics;
      emit(state.copyWith(biometricAvailable: available));
    } catch (e) {
      emit(
        state.copyWith(
          biometricAvailable: false,
          loginError: 'Failed to check biometric availability',
        ),
      );
    }
  }

  Future<void> _handleBiometricAuthentication(Emitter<LoginState> emit) async {
    if (!state.biometricAvailable) {
      emit(
        state.copyWith(loginError: 'Biometric authentication not available'),
      );
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
          IOSAuthMessages(cancelButton: 'Cancel'),
        ],
      );

      if (authenticated) {
        emit(
          state.copyWith(
            isLoading: false,
            loginSuccess: true,
            loginError: null,
          ),
        );
      } else {
        emit(
          state.copyWith(
            isLoading: false,
            loginError: 'Authentication failed',
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          loginError: 'Authentication error: ${e.toString()}',
        ),
      );
    }
  }

  void _togglePasswordVisibility(
      PasswordVisibilityChanged event,
      Emitter<LoginState> emit,
      ) {
    emit(state.copyWith(isPasswordVisible: !event.isPasswordVisible));
  }

  Future<void> _handleLoginSubmission(LoginSubmitted event, Emitter<LoginState> emit,) async {
    emit(
      state.copyWith(
        isLoading: true,
        username: event.username,
        password: event.password,
      ),
    );

    try {
      await Future.delayed(const Duration(seconds: 1));

      emit(state.copyWith(isLoading: false, loginSuccess: true));
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          loginError: 'Login failed. Please check your credentials.',
        ),
      );
    }
  }
}
