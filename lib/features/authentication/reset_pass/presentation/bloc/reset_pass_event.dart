

import 'package:flutter/cupertino.dart';

@immutable
sealed class ResetPasswordEvent {}

final class ResetPasswordRequested extends ResetPasswordEvent {
  final String email;
  ResetPasswordRequested(this.email);
}

final class ClearResetPasswordError extends ResetPasswordEvent {}

final class ResetPasswordReset extends ResetPasswordEvent {}