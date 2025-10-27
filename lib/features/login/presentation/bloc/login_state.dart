part of 'login_bloc.dart';

@immutable
class LoginState {

  final String username;
  final String password;
  final bool isLoading;
  final bool isPasswordVisible;
  final bool loginSuccess;
  final String? loginError;
  final bool biometricAvailable;

  const LoginState({
    this.username = '',
    this.password = '',
    this.isLoading = false,
    this.isPasswordVisible = false,
    this.loginSuccess = false,
    this.loginError,
    this.biometricAvailable = false,
  });

  LoginState copyWith({
    String? username,
    String? password,
    bool? isLoading,
    bool? isPasswordVisible,
    bool? loginSuccess,
    String? loginError,
    bool? biometricAvailable,
  }) {
    return LoginState(
      username: username ?? this.username,
      password: password ?? this.password,
      isLoading: isLoading ?? this.isLoading,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      loginSuccess: loginSuccess ?? this.loginSuccess,
      loginError: loginError ?? this.loginError,
      biometricAvailable: biometricAvailable ?? this.biometricAvailable,
    );
  }
}