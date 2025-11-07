
part of 'register_bloc.dart';

@immutable
sealed class RegisterEvent {}

final class PasswordVisibilityToggled extends RegisterEvent {}

final class ConfirmPasswordVisibilityToggled extends RegisterEvent {}

final class RegisterSubmitted extends RegisterEvent {
  final String username;
  final String password;
  final String confirmPassword;

  RegisterSubmitted(this.username, this.password, this.confirmPassword);
}

final class GoogleSignUpRequested extends RegisterEvent {}

final class FacebookSignUpRequested extends RegisterEvent {}

final class RegisterReset extends RegisterEvent {}

final class ClearRegisterError extends RegisterEvent {}