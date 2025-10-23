part of 'login_bloc.dart';

@immutable
class LoginState {
  final String username;
  final String password;
  final bool isLoading;
  final String? usernameError;
  final String? passwordError;
  final bool isPasswordVisible;
  final bool hasValidated;
  final bool isValid;
  final bool loginSuccess;
  final String? loginError;
  final bool biometricAvailable;

  const LoginState({
    this.username = '',
    this.password = '',
    this.isLoading = false,
    this.usernameError,
    this.passwordError,
    this.isPasswordVisible = false,
    this.hasValidated = false,
    this.isValid = false,
    this.loginSuccess = false,
    this.loginError,
    this.biometricAvailable = false,
  });

  LoginState copyWith({
    String? username,
    String? password,
    bool? isLoading,
    String? usernameError,
    String? passwordError,
    bool? isPasswordVisible,
    bool? hasValidated,
    bool? isValid,
    bool? loginSuccess,
    String? loginError,
    bool? biometricAvailable,
  }) {
    return LoginState(
      username: username ?? this.username,
      password: password ?? this.password,
      isLoading: isLoading ?? this.isLoading,
      usernameError: usernameError,
      passwordError: passwordError,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      hasValidated: hasValidated ?? this.hasValidated,
      isValid: isValid ?? this.isValid,
      loginSuccess: loginSuccess ?? this.loginSuccess,
      loginError: loginError,
      biometricAvailable: biometricAvailable ?? this.biometricAvailable,
    );
  }
}