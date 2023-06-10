import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:reward_randomizer/utils/icons.dart';
//AppLocalizations.of(context)!.

// A FormField allowing for editing a list of strings.
class RewardInput extends StatefulWidget {
  final List<String> rewards;
  final void Function(List<String>) onChanged;

  const RewardInput({
    Key? key,
    required this.rewards,
    required this.onChanged,
  }) : super(key: key);

  @override
  RewardInputState createState() => RewardInputState();
}

class RewardInputState extends State<RewardInput> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...widget.rewards.map(
          (reward) => Row(
            children: [
              Expanded(
                child: Text(
                  reward,
                  semanticsLabel: AppLocalizations.of(context)!
                      .rewardInputAccessibilitySingleReward(reward),
                ),
              ),
              IconButton(
                tooltip: AppLocalizations.of(context)!
                    .rewardInputAccessibilityDelete,
                onPressed: () {
                  setState(() {
                    widget.rewards.remove(reward);
                    widget.onChanged(widget.rewards);
                  });
                },
                icon: AppIcons.rewardDelete,
              ),
            ],
          ),
        ),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText:
                      AppLocalizations.of(context)!.pageAddActivitiesRewardHint,
                ),
              ),
            ),
            IconButton(
              tooltip:
                  AppLocalizations.of(context)!.rewardInputAccessibilityAdd,
              onPressed: () {
                setState(() {
                  widget.rewards.add(_controller.text);
                  widget.onChanged(widget.rewards);
                  _controller.clear();
                });
              },
              icon: AppIcons.rewardAdd,
            ),
          ],
        ),
      ],
    );
  }
}
