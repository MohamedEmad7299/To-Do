import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'on_board_event.dart';
part 'on_board_state.dart';

class OnBoardBloc extends Bloc<OnBoardEvent, OnBoardState> {
  OnBoardBloc() : super(OnBoardInitial()) {
    on<OnBoardEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
