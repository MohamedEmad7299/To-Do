part of 'on_board_bloc.dart';

@immutable
sealed class OnBoardEvent {}

class UpdateIndex extends OnBoardEvent {

  final int index;

  UpdateIndex(this.index);
}
