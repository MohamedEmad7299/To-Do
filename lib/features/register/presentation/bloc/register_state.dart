part of 'register_bloc.dart';

@immutable
final class RegisterState {
  final String username;
  final String password;
  final String confirmPassword;
  final bool isLoading;
  final bool isPasswordVisible;
  final bool isConfirmPasswordVisible;
  final bool registerSuccess;
  final String? registerError;

  const RegisterState({
    this.username = '',
    this.password = '',
    this.confirmPassword = '',
    this.isLoading = false,
    this.isPasswordVisible = false,
    this.isConfirmPasswordVisible = false,
    this.registerSuccess = false,
    this.registerError,
  });

  RegisterState copyWith({
    String? username,
    String? password,
    String? confirmPassword,
    bool? isLoading,
    bool? isPasswordVisible,
    bool? isConfirmPasswordVisible,
    bool? registerSuccess,
    String? registerError,
  }) {
    return RegisterState(
      username: username ?? this.username,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      isLoading: isLoading ?? this.isLoading,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      isConfirmPasswordVisible:
      isConfirmPasswordVisible ?? this.isConfirmPasswordVisible,
      registerSuccess: registerSuccess ?? this.registerSuccess,
      registerError: registerError ?? this.registerError,
    );
  }
}