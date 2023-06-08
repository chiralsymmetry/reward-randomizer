import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reward_randomizer/models/activity.dart';
import 'package:reward_randomizer/providers/preferences_provider.dart';
import 'package:reward_randomizer/providers/storage_provider.dart';
import 'package:reward_randomizer/services/storage.dart';
import 'package:reward_randomizer/utils/preferences.dart';

class ActivitiesNotifier extends StateNotifier<List<Activity>> {
  final Storage _storage;
  final Preferences _preferences;

  List<Activity> _storedActivities = [];
  Order _order = Order.oldestFirst;

  ActivitiesNotifier(this._storage, this._preferences) : super([]);

  void loadActivities() async {
    _storedActivities = await _storage.loadActivities();
    state = [..._storedActivities];
    _preferences.getOrder().then((preferredOrder) {
      _order = preferredOrder;
      _reorder();
    });
  }

  void addActivity(Activity activity) {
    _storedActivities = [..._storedActivities, activity];
    _storage.addActivity(activity);
    _reorder();
  }

  void updateActivity(Activity activity) {
    state = [
      for (final existingActivity in state)
        if (existingActivity.id == activity.id) activity else existingActivity,
    ];
    _storage.updateActivity(activity);
  }

  void removeActivity(Activity activity) {
    _storedActivities =
        _storedActivities.where((a) => a.id != activity.id).toList();
    _storage.removeActivity(activity);
    _reorder();
  }

  void reorderActivity(int oldIndex, int newIndex) {
    // When manually reordering, we assume the user wants to use the user-defined order.
    _order = Order.userDefined;
    final newState = [..._storedActivities];
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final activity = newState.removeAt(oldIndex);
    newState.insert(newIndex, activity);
    _preferences.setUserDefinedOrder(newState.map((e) => e.id).toList());
    state = newState;
  }

  void setOrder(Order order) {
    if (_order != order || order == Order.random) {
      _order = order;
      _preferences.setOrder(order);
      _reorder();
    }
  }

  Order getOrder() {
    return _order;
  }

  void _reorder() {
    final newState = [..._storedActivities];
    switch (_order) {
      case Order.oldestFirst:
        state = newState;
        break;
      case Order.newestFirst:
        state = newState.reversed.toList();
        break;
      case Order.alphabetical:
        // Note: we sort by label first, then by question, to have a secondary sort key.
        newState.sort(
            (a, b) => a.label.toLowerCase().compareTo(b.label.toLowerCase()));
        newState.sort((a, b) =>
            a.question.toLowerCase().compareTo(b.question.toLowerCase()));
        state = newState;
        break;
      case Order.reverseAlphabetical:
        // Note: label is sorted ascending, question descending.
        newState.sort(
            (a, b) => a.label.toLowerCase().compareTo(b.label.toLowerCase()));
        newState.sort((a, b) =>
            b.question.toLowerCase().compareTo(a.question.toLowerCase()));
        state = newState;
        break;
      case Order.labelAlphabetical:
        // Note: question first, then label.
        newState.sort((a, b) =>
            a.question.toLowerCase().compareTo(b.question.toLowerCase()));
        newState.sort(
            (a, b) => a.label.toLowerCase().compareTo(b.label.toLowerCase()));
        state = newState;
        break;
      case Order.labelReverseAlphabetical:
        // Note: question is sorted ascending, label descending.
        newState.sort((a, b) =>
            a.question.toLowerCase().compareTo(b.question.toLowerCase()));
        newState.sort(
            (a, b) => b.label.toLowerCase().compareTo(a.label.toLowerCase()));
        state = newState;
        break;
      case Order.userDefined:
        _preferences.getUserDefinedOrder().then((value) {
          newState.sort((a, b) => value.indexOf(a.id) - value.indexOf(b.id));
          state = newState;
        });
        break;
      case Order.random:
        newState.shuffle();
        state = newState;
        break;
    }
  }
}

final activitiesProvider =
    StateNotifierProvider<ActivitiesNotifier, List<Activity>>(
  (ref) {
    final storage = ref.read(storageProvider);
    final preferences = ref.read(preferencesProvider);
    return ActivitiesNotifier(storage, preferences);
  },
);
