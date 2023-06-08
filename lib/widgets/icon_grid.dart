import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_metadata/font_awesome_metadata.dart';
import 'package:reward_randomizer/providers/icon_selection_provider.dart';
import 'package:reward_randomizer/providers/selected_icon_provider.dart';

class IconGrid extends ConsumerStatefulWidget {
  const IconGrid({super.key});

  @override
  ConsumerState<IconGrid> createState() => _IconGridState();
}

class _IconGridState extends ConsumerState<IconGrid> {
  @override
  Widget build(BuildContext context) {
    final icons = ref.watch(iconSelectionProvider);
    final selectedIcon = ref.watch(selectedIconProvider);
    return GridView.count(
      crossAxisCount: 5,
      children: List.generate(
        icons.length,
        (index) {
          return GestureDetector(
            onTap: () {
              ref
                  .read(selectedIconProvider.notifier)
                  .setIcon(FaIcon(icons[index]));
              Navigator.pop(context);
            },
            child: Container(
              decoration: selectedIcon.icon == icons[index]
                  ? BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).colorScheme.primaryContainer,
                      border: Border.all(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                        width: 2,
                      ),
                    )
                  : null,
              child: Center(
                child: FaIcon(
                  icons[index],
                  size: 24,
                  color: selectedIcon.icon == icons[index]
                      ? Theme.of(context).colorScheme.onPrimaryContainer
                      : null,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
