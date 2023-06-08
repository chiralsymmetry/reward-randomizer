import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reward_randomizer/providers/locale_provider.dart';
import 'package:reward_randomizer/providers/preferences_provider.dart';

class LocalizedWidget extends ConsumerWidget {
  final Widget child;

  const LocalizedWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final localeNotifier = ref.read(localeProvider.notifier);
    if (localeNotifier.getSystemLocale() != null) {
      localeNotifier.setSystemLocale(Localizations.localeOf(context));
    }
    final preferences = ref.watch(preferencesProvider);
    preferences.getLocale(Localizations.localeOf(context)).then(
      (value) {
        if (value != locale) {
          ref.read(localeProvider.notifier).setLocale(value);
        }
      },
    );
    final Widget output;
    if (locale == Localizations.localeOf(context)) {
      output = child;
    } else {
      output = Localizations.override(
        context: context,
        locale: locale,
        child: Builder(
          builder: (_) => child,
        ),
      );
    }
    return output;
  }
}
