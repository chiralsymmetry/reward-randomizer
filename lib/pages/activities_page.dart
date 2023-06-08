import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reward_randomizer/pages/add_activity_page.dart';
import 'package:reward_randomizer/pages/preferences_page.dart';
import 'package:reward_randomizer/providers/activities_provider.dart';
import 'package:reward_randomizer/providers/icon_category_provider.dart';
import 'package:reward_randomizer/providers/icon_search_provider.dart';
import 'package:reward_randomizer/providers/icon_selection_provider.dart';
import 'package:reward_randomizer/providers/selected_icon_provider.dart';
import 'package:reward_randomizer/utils/icons.dart';
import 'package:reward_randomizer/utils/preferences.dart';
import 'package:reward_randomizer/widgets/activities_list.dart';
import 'package:reward_randomizer/widgets/default_page.dart';
import 'package:reward_randomizer/widgets/localized_widget.dart';
import 'package:reward_randomizer/widgets/reward.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'about_page.dart';

class ActivitiesPage extends ConsumerWidget {
  const ActivitiesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String orderToString(Order order) {
      final String output;
      switch (order) {
        case Order.oldestFirst:
          output = AppLocalizations.of(context)!.pageActivitiesOrderOldestFirst;
          break;
        case Order.newestFirst:
          output = AppLocalizations.of(context)!.pageActivitiesOrderNewestFirst;
          break;
        case Order.alphabetical:
          output = AppLocalizations.of(context)!
              .pageActivitiesOrderQuestionAscending;
          break;
        case Order.reverseAlphabetical:
          output = AppLocalizations.of(context)!
              .pageActivitiesOrderQuestionDescending;
          break;
        case Order.labelAlphabetical:
          output =
              AppLocalizations.of(context)!.pageActivitiesOrderLabelAscending;
          break;
        case Order.labelReverseAlphabetical:
          output =
              AppLocalizations.of(context)!.pageActivitiesOrderLabelDescending;
          break;
        case Order.userDefined:
          output = AppLocalizations.of(context)!.pageActivitiesOrderUserDefined;
          break;
        case Order.random:
          output = AppLocalizations.of(context)!.pageActivitiesOrderRandom;
          break;
      }
      return output;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.pageActivitiesAppBarTitle),
        backgroundColor: Theme.of(context).colorScheme.background,
        actions: [
          PopupMenuButton(
            icon: AppIcons.activitiesDropdownSort,
            itemBuilder: (context) {
              return [
                for (final order in Order.values)
                  PopupMenuItem(
                    value: order,
                    child: ListTile(
                      leading: order.icon,
                      title: Text(orderToString(order)),
                      selected: order ==
                          ref.read(activitiesProvider.notifier).getOrder(),
                    ),
                  )
              ];
            },
            onSelected: (v) {
              ref.read(activitiesProvider.notifier).setOrder(v);
            },
          ),
          IconButton(
            icon: AppIcons.activityAdd,
            onPressed: () {
              ref.read(iconSearchProvider.notifier).setSearchTerms("");
              ref.read(iconCategoryProvider.notifier).setCategory(null);
              ref.read(iconSelectionProvider.notifier).setSearchTerms("");
              ref.read(iconSelectionProvider.notifier).setCategory(null);
              ref.read(selectedIconProvider.notifier).setIcon(kDefaultIcon);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) =>
                      const LocalizedWidget(child: AddActivityPage()),
                ),
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  DrawerHeader(
                    decoration: BoxDecoration(
                        image: const DecorationImage(
                          image:
                              AssetImage("assets/reward_randomizer_icon.png"),
                          fit: BoxFit.none,
                          scale: 5.0,
                          opacity: 0.5,
                          alignment: Alignment.topLeft,
                        ),
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(context).colorScheme.background,
                            Theme.of(context).colorScheme.primaryContainer,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )),
                    child: Container(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        AppLocalizations.of(context)!.pageActivitiesAppBarTitle,
                        style: TextStyle(
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                          fontSize: 24,
                        ),
                      ),
                    ),
                  ),
                  ListTile(
                    leading: AppIcons.pageActivities,
                    title: Text(AppLocalizations.of(context)!
                        .pageActivitiesDrawerActivities),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  ListTile(
                    leading: AppIcons.settingsPage,
                    title: Text(AppLocalizations.of(context)!
                        .pagePreferencesAppBarTitle),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) =>
                              const LocalizedWidget(child: PreferencesPage()),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            ListTile(
              contentPadding: const EdgeInsets.only(left: 16, bottom: 16),
              leading: AppIcons.pageAbout,
              title: Text(AppLocalizations.of(context)!.pageAboutAppBarTitle),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      const LocalizedWidget(child: AboutPage()),
                ));
              },
            ),
          ],
        ),
      ),
      body: const DefaultPage(
        child: Column(
          children: [
            Reward(),
            ActivitiesList(),
          ],
        ),
      ),
    );
  }
}
