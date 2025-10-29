part of 'login_bloc.dart';

@immutable
sealed class LoginEvent {}

final class CheckBiometricAvailability extends LoginEvent {}

final class BiometricAuthenticationRequested extends LoginEvent {}

final class PasswordVisibilityChanged extends LoginEvent {
  final bool isPasswordVisible;
  PasswordVisibilityChanged(this.isPasswordVisible);
}

final class LoginSubmitted extends LoginEvent {
  final String username;
  final String password;

  LoginSubmitted(this.username, this.password);
}

final class LoginReset extends LoginEvent {}

final class ClearLoginError extends LoginEvent {}

final class BiometricAuthenticationCancelled extends LoginEvent {}