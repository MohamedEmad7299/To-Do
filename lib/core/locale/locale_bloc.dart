
import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/locale_service.dart';
import 'locale_event.dart';
import 'locale_state.dart';

class LocaleBloc extends Bloc<LocaleEvent, LocaleState> {
  final LocaleService _localeService;

  LocaleBloc({LocaleService? localeService})
      : _localeService = localeService ?? LocaleService(),
        super(LocaleState(locale: LocaleService.englishLocale)) {
    on<LoadSavedLocaleEvent>(_onLoadSavedLocale);
    on<ChangeLocaleEvent>(_onChangeLocale);
  }

  Future<void> _onLoadSavedLocale(
    LoadSavedLocaleEvent event,
    Emitter<LocaleState> emit,
  ) async {
    final savedLocale = await _localeService.getSavedLocale();
    if (savedLocale != null) {
      emit(LocaleState(locale: savedLocale));
    }
  }

  Future<void> _onChangeLocale(
    ChangeLocaleEvent event,
    Emitter<LocaleState> emit,
  ) async {
    await _localeService.saveLocale(event.locale);
    emit(LocaleState(locale: event.locale));
  }
}
