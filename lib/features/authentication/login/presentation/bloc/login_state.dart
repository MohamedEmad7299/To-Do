part of 'login_bloc.dart';

@immutable
sealed class LoginState {}

// Initial state
final class LoginInitial extends LoginState {}

// Username state
final class UsernameChanged extends LoginState {
  final String username;
  UsernameChanged(this.username);
}

// Password state
final class PasswordChanged extends LoginState {
  final String password;
  PasswordChanged(this.password);
}

// Loading state
final class LoginLoading extends LoginState {}

final class LoginNotLoading extends LoginState {}

// Password visibility state
final class PasswordVisible extends LoginState {}

final class PasswordHidden extends LoginState {}

// Login success state
final class LoginSuccessState extends LoginState {}

// Login error state
final class LoginErrorState extends LoginState {
  final String error;
  LoginErrorState(this.error);
}

final class LoginErrorCleared extends LoginState {}

// Biometric availability state
final class BiometricAvailable extends LoginState {}

final class BiometricNotAvailable extends LoginState {}