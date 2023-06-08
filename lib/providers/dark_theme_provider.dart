import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reward_randomizer/utils/preferences.dart';

class DarkThemeNotifier extends StateNotifier<DarkTheme?> {
  DarkThemeNotifier() : super(null);

  DarkTheme? getTheme() {
    return state;
  }

  void setTheme(DarkTheme? value) {
    state = value;
  }
}

final darkThemeProvider = StateNotifierProvider<DarkThemeNotifier, DarkTheme?>(
  (ref) {
    return DarkThemeNotifier();
  },
);
