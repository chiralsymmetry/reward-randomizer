import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:reward_randomizer/providers/dark_theme_provider.dart';
import 'package:reward_randomizer/providers/locale_provider.dart';
import 'package:reward_randomizer/providers/preferences_provider.dart';
import 'package:reward_randomizer/utils/icons.dart';
import 'package:reward_randomizer/utils/preferences.dart';
import 'package:reward_randomizer/widgets/default_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PreferencesPage extends ConsumerStatefulWidget {
  const PreferencesPage({super.key});

  @override
  ConsumerState<PreferencesPage> createState() => _PreferencesPageState();
}

Future<(double, DarkTheme, Language)> _getPreferences(
    Preferences preferences) async {
  return (
    await preferences.getCountdownDuration(),
    await preferences.getDarkTheme(),
    await preferences.getLanguage(),
  );
}

String _getDarkThemeString(DarkTheme darkTheme, BuildContext context) {
  switch (darkTheme) {
    case DarkTheme.system:
      return AppLocalizations.of(context)!.pagePreferencesDarkModeDefault;
    case DarkTheme.light:
      return AppLocalizations.of(context)!.pagePreferencesDarkModeLight;
    case DarkTheme.dark:
      return AppLocalizations.of(context)!.pagePreferencesDarkModeDark;
  }
}

class _PreferencesPageState extends ConsumerState<PreferencesPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final preferences = ref.watch(preferencesProvider);

    saveForm() {
      _formKey.currentState!.save();
      Navigator.of(context).pop();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.pagePreferencesAppBarTitle),
        backgroundColor: Theme.of(context).colorScheme.background,
        actions: [
          IconButton(
            tooltip:
                AppLocalizations.of(context)!.pagePreferencesAccessibilitySave,
            icon: AppIcons.settingsSave,
            onPressed: saveForm,
          ),
        ],
      ),
      body: DefaultPage(
        child: FutureBuilder(
          future: _getPreferences(preferences),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text(AppLocalizations.of(ctx)!.generalError),
              );
            } else {
              final (
                preferredCountdownDuration,
                preferredDarkTheme,
                preferredLanguage
              ) = snapshot.data as (double, DarkTheme, Language);
              final NumberFormat numberFormat = NumberFormat(
                "###.##",
                Localizations.localeOf(context).languageCode,
              );
              final countdownDurationString =
                  numberFormat.format(preferredCountdownDuration);
              return Form(
                key: _formKey,
                child: Column(
                  children: [
                    Row(
                      children: [
                        AppIcons.settingDelay,
                        const SizedBox(width: 8),
                        Expanded(
                          child: Semantics(
                            label: AppLocalizations.of(context)!
                                .pagePreferencesAccessibilitySave,
                            child: TextFormField(
                              keyboardType:
                                  const TextInputType.numberWithOptions(),
                              initialValue: countdownDurationString,
                              decoration: InputDecoration(
                                suffix: Text(AppLocalizations.of(ctx)!
                                    .pagePreferencesSecondsSuffix),
                              ),
                              onSaved: (newValue) {
                                if (newValue != null) {
                                  double value;
                                  try {
                                    value =
                                        numberFormat.parse(newValue).toDouble();
                                  } on FormatException {
                                    value = kCountdownDuration;
                                  }
                                  if (value < 0) {
                                    value = kCountdownDuration;
                                  }
                                  preferences.setCountdownDuration(value);
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        AppIcons.settingDarkMode,
                        const SizedBox(width: 8),
                        Expanded(
                          child: Semantics(
                            label: AppLocalizations.of(context)!
                                .pagePreferencesAccessibilityDarkTheme,
                            child: DropdownButtonFormField(
                              isExpanded: true,
                              isDense: false,
                              value: preferredDarkTheme,
                              items: [
                                for (final theme in DarkTheme.values)
                                  DropdownMenuItem(
                                    value: theme,
                                    child: Row(
                                      children: [
                                        theme.icon,
                                        const SizedBox(width: 8),
                                        Expanded(
                                            child: Text(_getDarkThemeString(
                                                theme, ctx))),
                                      ],
                                    ),
                                  )
                              ],
                              onChanged: (_) {},
                              onSaved: (newValue) {
                                if (newValue != null) {
                                  preferences.setDarkTheme(newValue);
                                  ref
                                      .read(darkThemeProvider.notifier)
                                      .setTheme(newValue);
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        AppIcons.settingLanguage,
                        const SizedBox(width: 8),
                        Expanded(
                          child: Semantics(
                            label: AppLocalizations.of(context)!
                                .pagePreferencesAccessibilityLanguage,
                            child: DropdownButtonFormField(
                              isExpanded: true,
                              isDense: false,
                              value: preferredLanguage,
                              items: [
                                for (final l in Language.values)
                                  DropdownMenuItem(
                                    value: l,
                                    child: Row(
                                      children: [
                                        if (l.flag.isEmpty)
                                          AppIcons.languageSystem
                                        else
                                          Row(
                                            children: [
                                              const SizedBox(width: 2),
                                              Text(l.flag),
                                              const SizedBox(width: 1),
                                            ],
                                          ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(l == Language.system
                                              ? AppLocalizations.of(ctx)!
                                                  .pagePreferencesLanguageDefault
                                              : l.nameInLanguage),
                                        ),
                                      ],
                                    ),
                                  )
                              ],
                              onChanged: (_) {},
                              onSaved: (newValue) {
                                if (newValue != null) {
                                  preferences.setLanguage(newValue);
                                  final locale = ref.read(localeProvider);
                                  if (newValue.localeCode !=
                                      locale?.languageCode) {
                                    ref
                                        .read(localeProvider.notifier)
                                        .setLocale(Locale(newValue.localeCode));
                                  }
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
