import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reward_randomizer/utils/preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesNotifier extends StateNotifier<Preferences> {
  PreferencesNotifier(preferences) : super(preferences);

  Future<void> setCountdownDuration(double value) async {
    if (value != await state.getCountdownDuration()) {
      state = await state.copyWith(countdownDuration: value);
    }
  }

  Future<void> setDarkTheme(DarkTheme value) async {
    if (value != await state.getDarkTheme()) {
      state = await state.copyWith(darkTheme: value);
    }
  }

  Future<void> setLanguage(Language value) async {
    if (value != await state.getLanguage()) {
      state = await state.copyWith(language: value);
    }
  }
}

final preferencesProvider = Provider<Preferences>(
  (ref) {
    final preferences = SharedPreferences.getInstance();
    return Preferences(preferences);
  },
);
