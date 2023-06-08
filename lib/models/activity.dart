import 'dart:math';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:uuid/uuid.dart';

Uuid uuid = const Uuid();
Random rnd = Random();

const int kDefaultReciprocal = 6;

class Activity {
  final String id;
  final FaIcon icon;
  final String label;
  final String question;
  final String answer;
  final int reciprocal;
  final List<String> rewards;

  Activity({
    String? id,
    required this.icon,
    required this.label,
    required this.question,
    required this.answer,
    int? reciprocal = kDefaultReciprocal,
    required this.rewards,
  })  : id = id ?? uuid.v4(),
        reciprocal = reciprocal ?? kDefaultReciprocal;

  String get randomReward {
    String output = "";
    if (rewards.isNotEmpty && rnd.nextDouble() < 1 / reciprocal) {
      output = rewards[rnd.nextInt(rewards.length)];
    }
    return output;
  }
}
