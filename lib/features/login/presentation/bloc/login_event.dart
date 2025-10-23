part of 'login_bloc.dart';

@immutable
sealed class LoginEvent {}

final class CheckBiometricAvailability extends LoginEvent {}

final class BiometricAuthenticationRequested extends LoginEvent {}

final class UsernameChanged extends LoginEvent {
  final String username;
  UsernameChanged(this.username);
}

final class PasswordChanged extends LoginEvent {
  final String password;
  PasswordChanged(this.password);
}

final class PasswordVisibilityChanged extends LoginEvent {
  final bool isPasswordVisible;
  PasswordVisibilityChanged(this.isPasswordVisible);
}

final class ValidateFields extends LoginEvent {}

final class LoginSubmitted extends LoginEvent {}

final class ClearUser extends LoginEvent {}

final class ClearPassword extends LoginEvent {}