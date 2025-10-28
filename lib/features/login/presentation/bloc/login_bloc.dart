import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_ios/types/auth_messages_ios.dart';

part 'login_event.dart';

part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({LocalAuthentication? auth}) : super(const LoginState()) {
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

    add(CheckBiometricAvailability());
  }

  Future<void> _checkBiometricAvailability(Emitter<LoginState> emit) async {
    try {
      final available = await LocalAuthentication().canCheckBiometrics;
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

    emit(state.copyWith(loginError: null));

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

      if (authenticated) {
        emit(state.copyWith(loginSuccess: true, loginError: null));
      } else {
        emit(state.copyWith(loginError: 'Authentication failed'));
        await LocalAuthentication().stopAuthentication();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void _togglePasswordVisibility(
    PasswordVisibilityChanged event,
    Emitter<LoginState> emit,
  ) {
    emit(state.copyWith(isPasswordVisible: !event.isPasswordVisible));
  }

  Future<void> _handleLoginSubmission(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
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
