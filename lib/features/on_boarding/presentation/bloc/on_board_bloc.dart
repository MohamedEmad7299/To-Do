

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'on_board_event.dart';
part 'on_board_state.dart';

class OnBoardBloc extends Bloc<OnBoardEvent,IndexState>{

  OnBoardBloc() : super(IndexState(0)){

    on<UpdateIndex>((event, emit) {
      final updatedIndex = event.index;
      emit(IndexState(updatedIndex));
    });
  }
}
