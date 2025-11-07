
import 'package:flutter/cupertino.dart';

@immutable
sealed class ResetPasswordState {}

final class ResetPasswordInitial extends ResetPasswordState {}

final class ResetPasswordLoading extends ResetPasswordState {}

final class ResetPasswordSuccess extends ResetPasswordState {}

final class ResetPasswordError extends ResetPasswordState {
  final String error;
  ResetPasswordError(this.error);
}

final class ResetPasswordErrorCleared extends ResetPasswordState {}