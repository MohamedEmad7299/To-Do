
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do/features/authentication/reset_pass/presentation/bloc/reset_pass_event.dart';
import 'package:to_do/features/authentication/reset_pass/presentation/bloc/reset_pass_state.dart';
import '../../../../../core/services/auth_service.dart';

class ResetPasswordBloc extends Bloc<ResetPasswordEvent, ResetPasswordState> {
  final AuthService _authService;

  ResetPasswordBloc({required AuthService authService})
      : _authService = authService,
        super(ResetPasswordInitial()) {
    on<ResetPasswordRequested>(_onResetPasswordRequested);
    on<ClearResetPasswordError>(_onClearError);
    on<ResetPasswordReset>(_onReset);
  }

  Future<void> _onResetPasswordRequested(
      ResetPasswordRequested event,
      Emitter<ResetPasswordState> emit,
      ) async {
    emit(ResetPasswordLoading());

    try {
      await _authService.resetPassword(email: event.email);
      emit(ResetPasswordSuccess());
    } catch (e) {
      emit(ResetPasswordError(e.toString()));
    }
  }

  void _onClearError(
      ClearResetPasswordError event,
      Emitter<ResetPasswordState> emit,
      ) {
    emit(ResetPasswordErrorCleared());
  }

  void _onReset(
      ResetPasswordReset event,
      Emitter<ResetPasswordState> emit,
      ) {
    emit(ResetPasswordInitial());
  }
}