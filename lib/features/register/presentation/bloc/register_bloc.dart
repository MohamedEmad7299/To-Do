import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {

  RegisterBloc() : super(const RegisterState()) {
    on<PasswordVisibilityChanged>(_onPasswordVisibilityChanged);
    on<ConfirmPasswordVisibilityChanged>(_onConfirmPasswordVisibilityChanged);
    on<RegisterSubmitted>(_onRegisterSubmitted);
    on<RegisterReset>(_onRegisterReset);
    on<ClearRegisterError>(_onClearRegisterError);
  }

  void _onPasswordVisibilityChanged(
      PasswordVisibilityChanged event,
      Emitter<RegisterState> emit,
      ) {
    emit(state.copyWith(isPasswordVisible: event.isPasswordVisible));
  }

  void _onConfirmPasswordVisibilityChanged(
      ConfirmPasswordVisibilityChanged event,
      Emitter<RegisterState> emit,
      ) {
    emit(state.copyWith(
        isConfirmPasswordVisible: event.isConfirmPasswordVisible));
  }

  Future<void> _onRegisterSubmitted(
      RegisterSubmitted event,
      Emitter<RegisterState> emit,
      ) async {
    emit(state.copyWith(
      isLoading: true,
      registerError: null,
    ));

    try {
      // TODO: Implement your registration logic here
      // Example:
      // final result = await authRepository.register(
      //   username: event.username,
      //   password: event.password,
      // );

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Simulate success
      emit(state.copyWith(
        isLoading: false,
        registerSuccess: true,
        username: event.username,
        password: event.password,
        confirmPassword: event.confirmPassword,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        registerError: e.toString(),
      ));
    }
  }

  void _onRegisterReset(
      RegisterReset event,
      Emitter<RegisterState> emit,
      ) {
    emit(const RegisterState());
  }

  void _onClearRegisterError(
      ClearRegisterError event,
      Emitter<RegisterState> emit,
      ) {
    emit(state.copyWith(registerError: null));
  }
}