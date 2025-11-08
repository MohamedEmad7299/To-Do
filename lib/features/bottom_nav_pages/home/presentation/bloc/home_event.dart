part of 'home_bloc.dart';

@immutable
sealed class HomeEvent {}

final class NavigationChanged extends HomeEvent {
  final int index;

  NavigationChanged(this.index);
}