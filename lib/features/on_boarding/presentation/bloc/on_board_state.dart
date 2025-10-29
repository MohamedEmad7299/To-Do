part of 'on_board_bloc.dart';

class OnboardingState extends Equatable {
  final int currentPage;
  final int totalPages;
  final bool shouldNavigateToWelcome;

  const OnboardingState({
    required this.currentPage,
    required this.totalPages,
    this.shouldNavigateToWelcome = false,
  });

  bool get isFirstPage => currentPage == 0;
  bool get isLastPage => currentPage == totalPages - 1;

  OnboardingState copyWith({
    int? currentPage,
    int? totalPages,
    bool? shouldNavigateToWelcome,
  }) {
    return OnboardingState(
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      shouldNavigateToWelcome: shouldNavigateToWelcome ?? false,
    );
  }

  @override
  List<Object?> get props => [currentPage, totalPages, shouldNavigateToWelcome];
}

