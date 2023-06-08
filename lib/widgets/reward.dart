import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reward_randomizer/providers/reward_provider.dart';

const _rewardBoxHeight = 150.0;
// TODO: Make size depend on screen size? Or add max font size to AutoSizeText?
const _fontSize = 64.0;

class Reward extends ConsumerWidget {
  const Reward({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reward = ref.watch(rewardProvider);

    return Container(
      height: _rewardBoxHeight,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: [
            Theme.of(context).colorScheme.secondary.withOpacity(0.26),
            Colors.transparent,
          ],
          radius: 1.0,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: AutoSizeText(
            reward,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .headlineLarge!
                .copyWith(fontSize: _fontSize),
          ),
        ),
      ),
    );
  }
}
