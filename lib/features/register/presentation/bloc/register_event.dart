part of 'register_bloc.dart';

@immutable
sealed class RegisterEvent {}

final class PasswordVisibilityChanged extends RegisterEvent {
  final bool isPasswordVisible;
  PasswordVisibilityChanged(this.isPasswordVisible);
}

final class ConfirmPasswordVisibilityChanged extends RegisterEvent {
  final bool isConfirmPasswordVisible;
  ConfirmPasswordVisibilityChanged(this.isConfirmPasswordVisible);
}

final class RegisterSubmitted extends RegisterEvent {
  final String username;
  final String password;
  final String confirmPassword;

  RegisterSubmitted(this.username, this.password, this.confirmPassword);
}

final class RegisterReset extends RegisterEvent {}

final class ClearRegisterError extends RegisterEvent {}