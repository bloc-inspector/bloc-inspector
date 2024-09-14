part of 'preferences_bloc.dart';

@freezed
class PreferencesState with _$PreferencesState {
  const factory PreferencesState.initial({
    bool? isDarkMode,
  }) = _Initial;
}
