part of 'register_bloc.dart';

@immutable
sealed class RegisterState {}

// Initial state
final class RegisterInitial extends RegisterState {}

// Loading state
final class RegisterLoading extends RegisterState {}

// Password visibility states
final class PasswordVisible extends RegisterState {}

final class PasswordHidden extends RegisterState {}

// Confirm password visibility states
final class ConfirmPasswordVisible extends RegisterState {}

final class ConfirmPasswordHidden extends RegisterState {}

// Register success state
final class RegisterSuccess extends RegisterState {}

// Register error state
final class RegisterError extends RegisterState {
  final String error;
  RegisterError(this.error);
}

final class RegisterErrorCleared extends RegisterState {}