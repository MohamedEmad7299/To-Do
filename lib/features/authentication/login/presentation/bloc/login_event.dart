part of 'login_bloc.dart';

@immutable
sealed class LoginEvent {}

final class CheckBiometricAvailability extends LoginEvent {}

final class BiometricAuthenticationRequested extends LoginEvent {
  final String localizedReason;
  final String signInTitle;
  final String cancelButton;

  BiometricAuthenticationRequested({
    required this.localizedReason,
    required this.signInTitle,
    required this.cancelButton,
  });
}

final class PasswordVisibilityChanged extends LoginEvent {
  final bool isPasswordVisible;
  PasswordVisibilityChanged(this.isPasswordVisible);
}

final class LoginSubmitted extends LoginEvent {
  final String username;
  final String password;

  LoginSubmitted(this.username, this.password);
}

// ADD: Google Sign In Event
final class GoogleSignInRequested extends LoginEvent {}

// ADD: Facebook Sign In Event
final class FacebookSignInRequested extends LoginEvent {}

final class LoginReset extends LoginEvent {}

final class ClearLoginError extends LoginEvent {}

final class BiometricAuthenticationCancelled extends LoginEvent {}