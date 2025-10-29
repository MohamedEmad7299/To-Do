

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'on_board_event.dart';
part 'on_board_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent,OnboardingState>{

  OnboardingBloc({required int totalPages})
      : super(OnboardingState(currentPage: 0, totalPages: totalPages)) {
    on<OnboardingPageChanged>(_onPageChanged);
    on<OnboardingNextPressed>(_onNextPressed);
    on<OnboardingBackPressed>(_onBackPressed);
    on<OnboardingSkipPressed>(_onSkipPressed);
  }

  void _onPageChanged(
      OnboardingPageChanged event,
      Emitter<OnboardingState> emit,
      ) {
    if (event.pageIndex >= 0 && event.pageIndex < state.totalPages) {
      emit(state.copyWith(currentPage: event.pageIndex));
    }
  }

  void _onNextPressed(
      OnboardingNextPressed event,
      Emitter<OnboardingState> emit,
      ) {
    if (state.isLastPage) {
      emit(state.copyWith(shouldNavigateToWelcome: true));
    } else {
      emit(state.copyWith(currentPage: state.currentPage + 1));
    }
  }

  void _onBackPressed(
      OnboardingBackPressed event,
      Emitter<OnboardingState> emit,
      ) {
    if (!state.isFirstPage) {
      emit(state.copyWith(currentPage: state.currentPage - 1));
    }
  }

  void _onSkipPressed(
      OnboardingSkipPressed event,
      Emitter<OnboardingState> emit,
      ) {
    emit(state.copyWith(shouldNavigateToWelcome: true));
  }
}
