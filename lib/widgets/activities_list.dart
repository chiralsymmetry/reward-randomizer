import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reward_randomizer/models/activity.dart';
import 'package:reward_randomizer/pages/add_activity_page.dart';
import 'package:reward_randomizer/providers/activities_provider.dart';
import 'package:reward_randomizer/providers/icon_category_provider.dart';
import 'package:reward_randomizer/providers/icon_search_provider.dart';
import 'package:reward_randomizer/providers/icon_selection_provider.dart';
import 'package:reward_randomizer/providers/preferences_provider.dart';
import 'package:reward_randomizer/providers/reward_provider.dart';
import 'package:reward_randomizer/providers/selected_icon_provider.dart';
import 'package:reward_randomizer/utils/icons.dart';
import 'package:reward_randomizer/widgets/localized_widget.dart';

class ActivitiesList extends ConsumerStatefulWidget {
  const ActivitiesList({super.key});

  @override
  ConsumerState<ActivitiesList> createState() => _ActivitiesListState();
}

class _ActivitiesListState extends ConsumerState<ActivitiesList> {
  bool _waiting = false;

  @override
  void initState() {
    super.initState();
    ref.read(activitiesProvider.notifier).loadActivities();
  }

  @override
  Widget build(BuildContext context) {
    List<Activity> activities = ref.watch(activitiesProvider);

    return LayoutBuilder(
      builder: (context, constraints) => ReorderableListView.builder(
        itemCount: activities.length,
        onReorder: ref.read(activitiesProvider.notifier).reorderActivity,
        itemBuilder: (BuildContext context, int index) {
          final currentActivity = activities[index];
          return Card(
            key: Key('$index'),
            child: GestureDetector(
              onTap: () {
                ref.read(iconSearchProvider.notifier).setSearchTerms("");
                ref.read(iconCategoryProvider.notifier).setCategory(null);
                ref.read(iconSelectionProvider.notifier).setSearchTerms("");
                ref.read(iconSelectionProvider.notifier).setCategory(null);
                ref
                    .read(selectedIconProvider.notifier)
                    .setIcon(currentActivity.icon);
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => LocalizedWidget(
                      child: AddActivityPage(activity: currentActivity)),
                ));
              },
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: currentActivity.icon,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(currentActivity.question,
                              style: Theme.of(context).textTheme.bodyLarge),
                          Text(
                            currentActivity.label,
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontStyle: FontStyle.italic,
                                ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: LimitedBox(
                      maxWidth: constraints.maxWidth * 0.3,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 5,
                        ),
                        onPressed: _waiting
                            ? null
                            : () async {
                                ref
                                    .read(rewardProvider.notifier)
                                    .setReward(currentActivity.randomReward);
                                setState(() {
                                  _waiting = true;
                                });
                                final seconds = await ref
                                    .read(preferencesProvider)
                                    .getCountdownDuration();
                                final milliseconds = (seconds * 1000).toInt();
                                Future.delayed(
                                    Duration(milliseconds: milliseconds), () {
                                  setState(() {
                                    _waiting = false;
                                  });
                                });
                              },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: _waiting
                              ? AppIcons.activityButtonWaiting
                              : Text(
                                  currentActivity.answer,
                                  textAlign: TextAlign.center,
                                ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
