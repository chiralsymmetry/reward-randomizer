import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reward_randomizer/providers/icon_search_provider.dart';
import 'package:reward_randomizer/providers/icon_selection_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class IconSearchInput extends ConsumerWidget {
  final TextEditingController textEditingController = TextEditingController();
  final FocusNode focusNode = FocusNode();

  IconSearchInput({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchTerms = ref.watch(iconSearchProvider);
    textEditingController.value = TextEditingValue(
      text: searchTerms,
      selection: TextSelection.collapsed(offset: searchTerms.length),
    );

    return TextField(
      controller: textEditingController,
      focusNode: focusNode,
      decoration: InputDecoration(
        hintText: AppLocalizations.of(context)!.pageAddActivitiesIconSearch,
      ),
      onChanged: (changedSearchTerms) {
        ref
            .read(iconSelectionProvider.notifier)
            .setSearchTerms(changedSearchTerms.toLowerCase().trim());
        ref
            .read(iconSearchProvider.notifier)
            .setSearchTerms(changedSearchTerms);
      },
    );
  }
}
