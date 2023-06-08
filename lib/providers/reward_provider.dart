import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reward_randomizer/providers/preferences_provider.dart';
import 'package:reward_randomizer/utils/preferences.dart';

class RewardNotifier extends StateNotifier<String> {
  final Preferences _preferences;

  RewardNotifier(this._preferences) : super("");

  Future<void> setReward(String reward) async {
    state = reward;
    final seconds = await _preferences.getCountdownDuration();
    final int milliseconds = (seconds * 1000).toInt();
    Future.delayed(Duration(milliseconds: milliseconds), () {
      state = "";
    });
  }
}

final rewardProvider = StateNotifierProvider<RewardNotifier, String>((ref) {
  final preferences = ref.watch(preferencesProvider);
  return RewardNotifier(preferences);
});
