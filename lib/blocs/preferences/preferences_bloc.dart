import 'package:bloc_inspector_client/helpers/logging_helper.dart';
import 'package:bloc_inspector_client/services/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'preferences_event.dart';
part 'preferences_state.dart';
part 'preferences_bloc.freezed.dart';

class PreferencesBloc extends Bloc<PreferencesEvent, PreferencesState> {
  PreferencesBloc() : super(const _Initial()) {
    on<_Init>(_init);
    on<_IsDarkModeChanged>(_isDarkModeChanged);

    add(const _Init());
  }

  void _init(_Init event, Emitter<PreferencesState> emit) async {
    final bool isDarkMode = await SharedPreferencesService().getIsDarkMode();

    emit(state.copyWith(
      isDarkMode: isDarkMode,
    ));

    logInfo("PreferencesBloc initialized");
  }

  void _isDarkModeChanged(
      _IsDarkModeChanged event, Emitter<PreferencesState> emit) async {
    await SharedPreferencesService().setIsDarkMode(event.darkMode);

    logInfo("Persisted darkMode: ${event.darkMode}");

    emit(state.copyWith(
      isDarkMode: event.darkMode,
    ));
  }
}
