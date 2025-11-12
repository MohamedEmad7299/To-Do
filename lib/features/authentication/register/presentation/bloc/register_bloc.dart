
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/services/auth_service.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {

  final AuthService _authService;

  RegisterBloc({required AuthService authService})
      : _authService = authService,
        super(RegisterInitial()) {
    on<PasswordVisibilityToggled>(_onPasswordVisibilityToggled);
    on<ConfirmPasswordVisibilityToggled>(_onConfirmPasswordVisibilityToggled);
    on<RegisterSubmitted>(_onRegisterSubmitted);
    on<GoogleSignUpRequested>(_onGoogleSignInRequested);
    on<FacebookSignUpRequested>(_onFacebookSignInRequested);
    on<RegisterReset>(_onRegisterReset);
    on<ClearRegisterError>(_onClearRegisterError);
  }

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  void _onPasswordVisibilityToggled(
      PasswordVisibilityToggled event,
      Emitter<RegisterState> emit,
      ) {
    _isPasswordVisible = !_isPasswordVisible;
    emit(_isPasswordVisible ? PasswordVisible() : PasswordHidden());
  }

  void _onConfirmPasswordVisibilityToggled(
      ConfirmPasswordVisibilityToggled event,
      Emitter<RegisterState> emit,
      ) {
    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
    emit(_isConfirmPasswordVisible
        ? ConfirmPasswordVisible()
        : ConfirmPasswordHidden());
  }

  Future<void> _onRegisterSubmitted(
      RegisterSubmitted event,
      Emitter<RegisterState> emit,
      ) async {
    emit(RegisterLoading());

    try {

      await _authService.signUp(
        email: event.username,
        password: event.password,
      );

      emit(RegisterSuccess());
    } catch (e) {
      emit(RegisterError(e.toString()));
    }
  }

  // ADD: Google Sign In Handler
  Future<void> _onGoogleSignInRequested(
      GoogleSignUpRequested event,
      Emitter<RegisterState> emit,
      ) async {
    emit(RegisterLoading());

    try {
      await _authService.continueWithGoogle();
      emit(RegisterSuccess());
    } catch (e) {
      emit(RegisterError(e.toString()));
    }
  }

  // ADD: Facebook Sign In Handler
  Future<void> _onFacebookSignInRequested(
      FacebookSignUpRequested event,
      Emitter<RegisterState> emit,
      ) async {
    emit(RegisterLoading());

    try {
      await _authService.continueWithFacebook();
      emit(RegisterSuccess());
    } catch (e) {
      emit(RegisterError(e.toString()));
    }
  }

  void _onRegisterReset(
      RegisterReset event,
      Emitter<RegisterState> emit,
      ) {
    _isPasswordVisible = false;
    _isConfirmPasswordVisible = false;
    emit(RegisterInitial());
  }

  void _onClearRegisterError(
      ClearRegisterError event,
      Emitter<RegisterState> emit,
      ) {
    emit(RegisterErrorCleared());
  }

  bool get isPasswordVisible => _isPasswordVisible;
  bool get isConfirmPasswordVisible => _isConfirmPasswordVisible;
}