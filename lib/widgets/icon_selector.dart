import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reward_randomizer/providers/icon_category_provider.dart';
import 'package:reward_randomizer/providers/icon_search_provider.dart';
import 'package:reward_randomizer/providers/icon_selection_provider.dart';
import 'package:reward_randomizer/providers/selected_icon_provider.dart';
import 'package:reward_randomizer/widgets/icon_category_selector.dart';
import 'package:reward_randomizer/widgets/icon_search_input.dart';
import 'package:reward_randomizer/widgets/icon_grid.dart';
import 'package:reward_randomizer/widgets/localized_widget.dart';

const double _popupMenuButtonWidth = 240.0;
const double _popupMenuButtonHeight = 360.0;
const double _iconGridHeight = _popupMenuButtonHeight - 150.0;

class IconSelector extends ConsumerStatefulWidget {
  const IconSelector({super.key});

  @override
  ConsumerState<IconSelector> createState() => _IconSelectorState();
}

class _IconSelectorState extends ConsumerState<IconSelector> {
  @override
  Widget build(BuildContext context) {
    final selectedIcon = ref.watch(selectedIconProvider);
    return PopupMenuButton(
      constraints: const BoxConstraints.expand(
        width: _popupMenuButtonWidth,
        height: _popupMenuButtonHeight,
      ),
      icon: selectedIcon,
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            enabled: false,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(child: LocalizedWidget(child: IconSearchInput())),
                    IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        ref
                            .read(iconCategoryProvider.notifier)
                            .setCategory(null);
                        ref
                            .read(iconSearchProvider.notifier)
                            .setSearchTerms("");
                        ref
                            .read(iconSelectionProvider.notifier)
                            .setCategory(null);
                        ref
                            .read(iconSelectionProvider.notifier)
                            .setSearchTerms("");
                      },
                    ),
                  ],
                ),
                Container(
                  width: _popupMenuButtonWidth,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 0,
                    vertical: 16,
                  ),
                  child: Theme(
                      data: Theme.of(context).copyWith(
                          disabledColor: Theme.of(context).primaryColor),
                      child:
                          const LocalizedWidget(child: IconCategorySelector())),
                ),
              ],
            ),
          ),
          PopupMenuItem(
            padding: const EdgeInsets.all(0),
            enabled: false,
            child: Theme(
              data: Theme.of(context)
                  .copyWith(disabledColor: Theme.of(context).primaryColor),
              child: const SizedBox(
                width: _popupMenuButtonWidth,
                height: _iconGridHeight,
                child: IconGrid(),
              ),
            ),
          ),
        ];
      },
    );
  }
}
