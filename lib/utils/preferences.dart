import 'package:flutter/material.dart';
import 'package:reward_randomizer/utils/icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum DarkTheme {
  system(AppIcons.darkModeSystem),
  light(AppIcons.darkModeLight),
  dark(AppIcons.darkModeDark);

  final Icon icon;
  const DarkTheme(this.icon);
}

enum Language {
  system("system", "", ""),
  english("en", "🇺🇸", "English"),
  swedish("sv", "🇸🇪", "Svenska");

  final String localeCode;
  final String flag;
  final String nameInLanguage;
  const Language(this.localeCode, this.flag, this.nameInLanguage);
}

enum Order {
  oldestFirst(AppIcons.activityOrderOldestFirst),
  newestFirst(AppIcons.activityOrderNewestFirst),
  alphabetical(AppIcons.activityOrderQuestionAscending),
  reverseAlphabetical(AppIcons.activityOrderQuestionDescending),
  labelAlphabetical(AppIcons.activityOrderLabelAscending),
  labelReverseAlphabetical(AppIcons.activityOrderLabelDescending),
  userDefined(AppIcons.activityOrderUserDefined),
  random(AppIcons.activityOrderRandom);

  final Icon icon;
  const Order(this.icon);
}

double kCountdownDuration = 3;
const _countdownDurationKey = "countdownDuration";
const _darkThemeKey = "darkTheme";
const _languageKey = "language";
const _orderKey = "order";
const _userDefinedOrder = "userDefinedOrder";

class Preferences {
  final Future<SharedPreferences> _futurePreferences;

  const Preferences(this._futurePreferences);

  Future<Preferences> copyWith({
    double? countdownDuration,
    DarkTheme? darkTheme,
    Language? language,
    Order? order,
    List<String>? userDefinedOrder,
  }) async {
    if (countdownDuration != null) {
      setCountdownDuration(countdownDuration);
    }
    if (darkTheme != null) {
      setDarkTheme(darkTheme);
    }
    if (language != null) {
      setLanguage(language);
    }
    if (order != null) {
      setOrder(order);
    }
    if (userDefinedOrder != null) {
      setUserDefinedOrder(userDefinedOrder);
    }
    return Preferences(
      _futurePreferences,
    );
  }

  void setCountdownDuration(double value) async {
    final preferences = await _futurePreferences;
    preferences.setDouble(_countdownDurationKey, value);
  }

  Future<double> getCountdownDuration() async {
    final preferences = await _futurePreferences;
    if (!preferences.containsKey(_countdownDurationKey)) {
      setCountdownDuration(kCountdownDuration);
    }
    return preferences.getDouble(_countdownDurationKey) ?? kCountdownDuration;
  }

  void setDarkTheme(DarkTheme value) async {
    final preferences = await _futurePreferences;
    preferences.setInt(_darkThemeKey, value.index);
  }

  Future<DarkTheme> getDarkTheme() async {
    final preferences = await _futurePreferences;
    if (!preferences.containsKey(_darkThemeKey)) {
      setDarkTheme(DarkTheme.system);
    }
    return DarkTheme.values[preferences.getInt(_darkThemeKey) ?? 0];
  }

  void setLanguage(Language value) async {
    final preferences = await _futurePreferences;
    preferences.setInt(_languageKey, value.index);
  }

  Future<Language> getLanguage() async {
    final preferences = await _futurePreferences;
    return Language.values[preferences.getInt(_languageKey) ?? 0];
  }

  void setLocale(Locale locale) {
    Language newLanguage = Language.system;
    for (final language in Language.values) {
      if (language.localeCode == locale.languageCode) {
        newLanguage = language;
        break;
      }
    }
    setLanguage(newLanguage);
  }

  Future<Locale> getLocale(Locale systemLocale) async {
    final language = await getLanguage();
    final Locale output;
    if (language.localeCode == Language.system.localeCode) {
      output = systemLocale;
    } else {
      output = Locale(language.localeCode);
    }
    return output;
  }

  void setOrder(Order order) async {
    final preferences = await _futurePreferences;
    preferences.setInt(_orderKey, order.index);
  }

  Future<Order> getOrder() async {
    final preferences = await _futurePreferences;
    if (!preferences.containsKey(_orderKey)) {
      setOrder(Order.oldestFirst);
    }
    return Order.values[preferences.getInt(_orderKey) ?? 0];
  }

  void setUserDefinedOrder(List<String> value) async {
    final preferences = await _futurePreferences;
    preferences.setStringList(_userDefinedOrder, value);
  }

  Future<List<String>> getUserDefinedOrder() async {
    final preferences = await _futurePreferences;
    if (!preferences.containsKey(_userDefinedOrder)) {
      setUserDefinedOrder([]);
    }
    return preferences.getStringList(_userDefinedOrder) ?? [];
  }
}
