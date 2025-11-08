part of 'home_bloc.dart';

@immutable
sealed class HomeState {
  final int currentIndex;

  const HomeState({required this.currentIndex});
}

final class HomeInitial extends HomeState {
  const HomeInitial({required super.currentIndex});
}

final class NavigationState extends HomeState {
  const NavigationState({required super.currentIndex});
}