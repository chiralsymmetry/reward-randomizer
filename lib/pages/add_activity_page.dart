import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reward_randomizer/models/activity.dart';
import 'package:reward_randomizer/providers/activities_provider.dart';
import 'package:reward_randomizer/providers/selected_icon_provider.dart';
import 'package:reward_randomizer/utils/icons.dart';
import 'package:reward_randomizer/widgets/default_page.dart';
import 'package:reward_randomizer/widgets/icon_selector.dart';
import 'package:reward_randomizer/widgets/reward_input.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddActivityPage extends ConsumerStatefulWidget {
  final Activity? activity;

  const AddActivityPage({super.key, this.activity});

  @override
  ConsumerState<AddActivityPage> createState() => _AddActivityPageState();
}

List<String> _splitDefaultRewards(String localizedRewards) {
  return localizedRewards.split("|");
}

class _AddActivityPageState extends ConsumerState<AddActivityPage> {
  final _formKey = GlobalKey<FormState>();
  String _label = "";
  String _question = "";
  String? _answer;
  int? _reciprocal;
  List<String> _rewards = [];
  String _chanceString = "";

  @override
  void initState() {
    super.initState();
    if (widget.activity != null) {
      setState(() {
        _label = widget.activity!.label;
        _question = widget.activity!.question;
        _answer = widget.activity!.answer;
        _reciprocal = widget.activity!.reciprocal;
        _rewards = widget.activity!.rewards.toList();
      });
    }
  }

  _setChanceString(int? userReciprocal) {
    int reciprocal = userReciprocal ?? kDefaultReciprocal;
    double p = 1.0 / reciprocal;
    String equal = p == p.toInt()
        ? AppLocalizations.of(context)!.pageAddActivitiesChanceEqual
        : AppLocalizations.of(context)!.pageAddActivitiesChanceApprox;
    setState(() {
      _chanceString = AppLocalizations.of(context)!
          .pageAddActivitiesChanceText(reciprocal, equal, p);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.activity == null && _rewards.isEmpty) {
      _rewards =
          _splitDefaultRewards(AppLocalizations.of(context)!.defaultRewards);
    }
    saveActivity() {
      _formKey.currentState?.save();
      final activity = Activity(
        id: widget.activity?.id,
        icon: ref.read(selectedIconProvider),
        label: _label,
        question: _question,
        answer: _answer ??
            AppLocalizations.of(context)!.pageAddActivitiesAnswerDefaultYes,
        reciprocal: _reciprocal,
        rewards: _rewards,
      );
      if (widget.activity != null) {
        ref.read(activitiesProvider.notifier).updateActivity(activity);
      } else {
        ref.read(activitiesProvider.notifier).addActivity(activity);
      }
      Navigator.pop(context);
    }

    deleteActivity() {
      showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Text(
                AppLocalizations.of(ctx)!.pageAddActivitiesDeleteDialogTitle),
            content: Text(
                AppLocalizations.of(ctx)!.pageAddActivitiesDeleteDialogText),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                },
                child: Text(AppLocalizations.of(ctx)!
                    .pageAddActivitiesDeleteDialogCancel),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  ref
                      .read(activitiesProvider.notifier)
                      .removeActivity(widget.activity!);
                  Navigator.pop(ctx);
                },
                child: Text(AppLocalizations.of(ctx)!
                    .pageAddActivitiesDeleteDialogConfirm),
              ),
            ],
          );
        },
      );
    }

    if (_chanceString.isEmpty) {
      _setChanceString(_reciprocal);
    }

    return Scaffold(
      appBar: AppBar(
        title: (widget.activity != null)
            ? Text(
                AppLocalizations.of(context)!.pageAddActivitiesAppBarTitleEdit)
            : Text(
                AppLocalizations.of(context)!.pageAddActivitiesAppBarTitleAdd),
        backgroundColor: Theme.of(context).colorScheme.background,
        actions: [
          if (widget.activity != null)
            IconButton(
              icon: AppIcons.activityDelete,
              onPressed: deleteActivity,
            ),
          IconButton(
            icon: AppIcons.activitySave,
            onPressed: saveActivity,
          ),
        ],
      ),
      body: DefaultPage(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.always,
              child: Column(
                children: [
                  Row(
                    children: [
                      const Padding(
                        padding:
                            EdgeInsets.only(left: 16.0, right: 32.0, top: 8.0),
                        child: IconSelector(),
                      ),
                      Expanded(
                        child: TextFormField(
                          initialValue: _label,
                          onSaved: (newValue) {
                            _label = newValue ?? "";
                          },
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)!
                                .pageAddActivitiesLabelHint,
                          ),
                        ),
                      ),
                    ],
                  ),
                  TextFormField(
                    initialValue: _question,
                    onSaved: (newValue) {
                      _question = newValue ?? "";
                    },
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!
                          .pageAddActivitiesQuestionHint,
                    ),
                  ),
                  TextFormField(
                    initialValue: _answer,
                    onSaved: (newValue) {
                      if (newValue != null && newValue.isEmpty) {
                        _answer = null;
                      } else {
                        _answer = newValue;
                      }
                    },
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!
                          .pageAddActivitiesAnswerHint,
                      hintText: AppLocalizations.of(context)!
                          .pageAddActivitiesAnswerDefaultYes,
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: TextFormField(
                          initialValue: _reciprocal?.toString(),
                          onSaved: (newValue) {
                            _reciprocal = int.tryParse(newValue ?? "");
                          },
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: false, signed: false),
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)!
                                .pageAddActivitiesChanceHint,
                            hintText: kDefaultReciprocal.toString(),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _setChanceString(int.tryParse(value));
                            });
                          },
                        ),
                      ),
                      Padding(
                      padding: const EdgeInsets.only(bottom: 12.0, left: 12.0),
                        child: Text(_chanceString),
                      ),
                    ],
                  ),
                  RewardInput(
                      rewards: _rewards,
                      onChanged: (s) {
                        _rewards = s;
                      }),
                ],
              ),
            ),
        ),
      ),
    );
  }
}
