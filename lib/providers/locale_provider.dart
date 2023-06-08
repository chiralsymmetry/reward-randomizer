import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reward_randomizer/utils/preferences.dart';

class LocaleNotifier extends StateNotifier<Locale?> {
  Locale? systemLocale;

  LocaleNotifier() : super(null);

  void setSystemLocale(Locale value) {
    systemLocale = value;
  }

  Locale? getSystemLocale() {
    return systemLocale;
  }

  Locale getLocale(Locale systemLocale) {
    return state ?? systemLocale;
  }

  void setLocale(Locale value) {
    if (value.languageCode == Language.system.localeCode) {
      state = systemLocale;
    } else {
      state = value;
    }
  }
}

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale?>(
  (ref) {
    return LocaleNotifier();
  },
);
