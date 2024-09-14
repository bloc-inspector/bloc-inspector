part of 'preferences_bloc.dart';

@freezed
class PreferencesEvent with _$PreferencesEvent {
  const factory PreferencesEvent.init() = _Init;
  const factory PreferencesEvent.isDarkModeChanged(bool darkMode) =
      _IsDarkModeChanged;
}
