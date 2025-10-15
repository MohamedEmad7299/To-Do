part of 'on_board_bloc.dart';

@immutable
sealed class OnBoardState {}

final class IndexState extends OnBoardState {

  final int index;

  IndexState(this.index);

}

