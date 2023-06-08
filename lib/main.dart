import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reward_randomizer/pages/activities_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:reward_randomizer/providers/dark_theme_provider.dart';
import 'package:reward_randomizer/providers/preferences_provider.dart';
import 'package:reward_randomizer/utils/preferences.dart';
import 'package:reward_randomizer/widgets/localized_widget.dart';

const _beige = Color.fromRGBO(246, 243, 223, 1.0);
const _lightGold = Color.fromRGBO(182, 155, 0, 1.0);
const _bronzeYellow = Color.fromRGBO(114, 97, 0, 1.0);
final _colorScheme = ColorScheme.fromSeed(
  seedColor: _lightGold,
).copyWith(
  background: _beige,
);
final _colorSchemeDark = ColorScheme.fromSeed(
  seedColor: _lightGold,
  brightness: Brightness.dark,
).copyWith(
  background: _bronzeYellow,
);
final ThemeData _lightTheme =
    ThemeData.from(colorScheme: _colorScheme, useMaterial3: true);
final ThemeData _darkTheme =
    ThemeData.from(colorScheme: _colorSchemeDark, useMaterial3: true);

void main() {
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends ConsumerWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final preferredDarkTheme = ref.watch(darkThemeProvider);
    if (preferredDarkTheme == null) {
      final preferences = ref.watch(preferencesProvider);
      preferences.getDarkTheme().then(
        (value) {
          ref.read(darkThemeProvider.notifier).setTheme(value);
        },
      );
    }
    final ThemeData lightThemeToUse;
    final ThemeData darkThemeToUse;
    if (preferredDarkTheme != null && preferredDarkTheme == DarkTheme.light) {
      lightThemeToUse = _lightTheme;
      darkThemeToUse = _lightTheme;
    } else if (preferredDarkTheme != null &&
        preferredDarkTheme == DarkTheme.dark) {
      lightThemeToUse = _darkTheme;
      darkThemeToUse = _darkTheme;
    } else {
      lightThemeToUse = _lightTheme;
      darkThemeToUse = _darkTheme;
    }

    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: lightThemeToUse,
      darkTheme: darkThemeToUse,
      home: const LocalizedWidget(child: ActivitiesPage()),
    );
  }
}
