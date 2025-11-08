import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial(currentIndex: 0)) {
    on<NavigationChanged>(_onNavigationChanged);
  }

  void _onNavigationChanged(NavigationChanged event, Emitter<HomeState> emit) {
    emit(NavigationState(currentIndex: event.index));
  }
}