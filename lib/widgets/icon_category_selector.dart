import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reward_randomizer/providers/icon_category_provider.dart';
import 'package:reward_randomizer/providers/icon_selection_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_metadata/font_awesome_metadata.dart' as fa;

class IconCategorySelector extends ConsumerWidget {
  const IconCategorySelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategory = ref.watch(iconCategoryProvider);
    final labels = _getCategoryLabels(context);
    final categoriesOrdered = labels.keys.toList();
    categoriesOrdered.sort(
      (a, b) => labels[a]!.compareTo(labels[b]!),
    );
    return PopupMenuButton(
      child: ListTile(
        contentPadding: const EdgeInsets.all(0),
        trailing: Icon(
          Icons.arrow_drop_down,
          color: Theme.of(context).colorScheme.onPrimaryContainer,
        ),
        title: Text(
          selectedCategory != null
              ? labels[selectedCategory]!
              : AppLocalizations.of(context)!.pageAddActivitiesIconCategory,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: Theme.of(context).colorScheme.onPrimaryContainer),
        ),
      ),
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            padding: EdgeInsets.zero,
            child: const Text(""),
            onTap: () {
              ref.read(iconSelectionProvider.notifier).setCategory(null);
              ref.read(iconCategoryProvider.notifier).setCategory(null);
            },
          ),
          for (final category in categoriesOrdered)
            PopupMenuItem(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              value: category,
              onTap: () {
                ref.read(iconSelectionProvider.notifier).setCategory(category);
                ref.read(iconCategoryProvider.notifier).setCategory(category);
              },
              child: Row(
                children: [
                  if (category == selectedCategory)
                    Icon(
                      Icons.check,
                      size: 18,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    )
                  else
                    const SizedBox(width: 18),
                  Expanded(child: Text(labels[category]!)),
                ],
              ),
            )
        ];
      },
    );
  }
}

Map<fa.IconCategory, String> _getCategoryLabels(BuildContext context) {
  final labels = <fa.IconCategory, String>{};
  labels[fa.FaIconCategory.accessibility] =
      AppLocalizations.of(context)!.faIconCategoryAccessibility;
  labels[fa.FaIconCategory.alert] =
      AppLocalizations.of(context)!.faIconCategoryAlert;
  labels[fa.FaIconCategory.alphabet] =
      AppLocalizations.of(context)!.faIconCategoryAlphabet;
  labels[fa.FaIconCategory.animals] =
      AppLocalizations.of(context)!.faIconCategoryAnimals;
  labels[fa.FaIconCategory.arrows] =
      AppLocalizations.of(context)!.faIconCategoryArrows;
  labels[fa.FaIconCategory.astronomy] =
      AppLocalizations.of(context)!.faIconCategoryAstronomy;
  labels[fa.FaIconCategory.automotive] =
      AppLocalizations.of(context)!.faIconCategoryAutomotive;
  labels[fa.FaIconCategory.buildings] =
      AppLocalizations.of(context)!.faIconCategoryBuildings;
  labels[fa.FaIconCategory.business] =
      AppLocalizations.of(context)!.faIconCategoryBusiness;
  labels[fa.FaIconCategory.camping] =
      AppLocalizations.of(context)!.faIconCategoryCamping;
  labels[fa.FaIconCategory.charity] =
      AppLocalizations.of(context)!.faIconCategoryCharity;
  labels[fa.FaIconCategory.chartsDiagrams] =
      AppLocalizations.of(context)!.faIconCategoryChartsDiagrams;
  labels[fa.FaIconCategory.childhood] =
      AppLocalizations.of(context)!.faIconCategoryChildhood;
  labels[fa.FaIconCategory.clothingFashion] =
      AppLocalizations.of(context)!.faIconCategoryClothingFashion;
  labels[fa.FaIconCategory.coding] =
      AppLocalizations.of(context)!.faIconCategoryCoding;
  labels[fa.FaIconCategory.communication] =
      AppLocalizations.of(context)!.faIconCategoryCommunication;
  labels[fa.FaIconCategory.connectivity] =
      AppLocalizations.of(context)!.faIconCategoryConnectivity;
  labels[fa.FaIconCategory.construction] =
      AppLocalizations.of(context)!.faIconCategoryConstruction;
  labels[fa.FaIconCategory.design] =
      AppLocalizations.of(context)!.faIconCategoryDesign;
  labels[fa.FaIconCategory.devicesHardware] =
      AppLocalizations.of(context)!.faIconCategoryDevicesHardware;
  labels[fa.FaIconCategory.disaster] =
      AppLocalizations.of(context)!.faIconCategoryDisaster;
  labels[fa.FaIconCategory.editing] =
      AppLocalizations.of(context)!.faIconCategoryEditing;
  labels[fa.FaIconCategory.education] =
      AppLocalizations.of(context)!.faIconCategoryEducation;
  labels[fa.FaIconCategory.emoji] =
      AppLocalizations.of(context)!.faIconCategoryEmoji;
  labels[fa.FaIconCategory.energy] =
      AppLocalizations.of(context)!.faIconCategoryEnergy;
  labels[fa.FaIconCategory.files] =
      AppLocalizations.of(context)!.faIconCategoryFiles;
  labels[fa.FaIconCategory.filmVideo] =
      AppLocalizations.of(context)!.faIconCategoryFilmVideo;
  labels[fa.FaIconCategory.foodBeverage] =
      AppLocalizations.of(context)!.faIconCategoryFoodBeverage;
  labels[fa.FaIconCategory.fruitsVegetables] =
      AppLocalizations.of(context)!.faIconCategoryFruitsVegetables;
  labels[fa.FaIconCategory.gaming] =
      AppLocalizations.of(context)!.faIconCategoryGaming;
  labels[fa.FaIconCategory.gender] =
      AppLocalizations.of(context)!.faIconCategoryGender;
  labels[fa.FaIconCategory.halloween] =
      AppLocalizations.of(context)!.faIconCategoryHalloween;
  labels[fa.FaIconCategory.hands] =
      AppLocalizations.of(context)!.faIconCategoryHands;
  labels[fa.FaIconCategory.holidays] =
      AppLocalizations.of(context)!.faIconCategoryHolidays;
  labels[fa.FaIconCategory.household] =
      AppLocalizations.of(context)!.faIconCategoryHousehold;
  labels[fa.FaIconCategory.humanitarian] =
      AppLocalizations.of(context)!.faIconCategoryHumanitarian;
  labels[fa.FaIconCategory.logistics] =
      AppLocalizations.of(context)!.faIconCategoryLogistics;
  labels[fa.FaIconCategory.maps] =
      AppLocalizations.of(context)!.faIconCategoryMaps;
  labels[fa.FaIconCategory.maritime] =
      AppLocalizations.of(context)!.faIconCategoryMaritime;
  labels[fa.FaIconCategory.marketing] =
      AppLocalizations.of(context)!.faIconCategoryMarketing;
  labels[fa.FaIconCategory.mathematics] =
      AppLocalizations.of(context)!.faIconCategoryMathematics;
  labels[fa.FaIconCategory.mediaPlayback] =
      AppLocalizations.of(context)!.faIconCategoryMediaPlayback;
  labels[fa.FaIconCategory.medicalHealth] =
      AppLocalizations.of(context)!.faIconCategoryMedicalHealth;
  labels[fa.FaIconCategory.money] =
      AppLocalizations.of(context)!.faIconCategoryMoney;
  labels[fa.FaIconCategory.moving] =
      AppLocalizations.of(context)!.faIconCategoryMoving;
  labels[fa.FaIconCategory.musicAudio] =
      AppLocalizations.of(context)!.faIconCategoryMusicAudio;
  labels[fa.FaIconCategory.nature] =
      AppLocalizations.of(context)!.faIconCategoryNature;
  labels[fa.FaIconCategory.numbers] =
      AppLocalizations.of(context)!.faIconCategoryNumbers;
  labels[fa.FaIconCategory.photosImages] =
      AppLocalizations.of(context)!.faIconCategoryPhotosImages;
  labels[fa.FaIconCategory.political] =
      AppLocalizations.of(context)!.faIconCategoryPolitical;
  labels[fa.FaIconCategory.punctuationSymbols] =
      AppLocalizations.of(context)!.faIconCategoryPunctuationSymbols;
  labels[fa.FaIconCategory.religion] =
      AppLocalizations.of(context)!.faIconCategoryReligion;
  labels[fa.FaIconCategory.science] =
      AppLocalizations.of(context)!.faIconCategoryScience;
  labels[fa.FaIconCategory.scienceFiction] =
      AppLocalizations.of(context)!.faIconCategoryScienceFiction;
  labels[fa.FaIconCategory.security] =
      AppLocalizations.of(context)!.faIconCategorySecurity;
  labels[fa.FaIconCategory.shapes] =
      AppLocalizations.of(context)!.faIconCategoryShapes;
  labels[fa.FaIconCategory.shopping] =
      AppLocalizations.of(context)!.faIconCategoryShopping;
  labels[fa.FaIconCategory.social] =
      AppLocalizations.of(context)!.faIconCategorySocial;
  labels[fa.FaIconCategory.spinners] =
      AppLocalizations.of(context)!.faIconCategorySpinners;
  labels[fa.FaIconCategory.sportsFitness] =
      AppLocalizations.of(context)!.faIconCategorySportsFitness;
  labels[fa.FaIconCategory.textFormatting] =
      AppLocalizations.of(context)!.faIconCategoryTextFormatting;
  labels[fa.FaIconCategory.time] =
      AppLocalizations.of(context)!.faIconCategoryTime;
  labels[fa.FaIconCategory.toggle] =
      AppLocalizations.of(context)!.faIconCategoryToggle;
  labels[fa.FaIconCategory.transportation] =
      AppLocalizations.of(context)!.faIconCategoryTransportation;
  labels[fa.FaIconCategory.travelHotel] =
      AppLocalizations.of(context)!.faIconCategoryTravelHotel;
  labels[fa.FaIconCategory.usersPeople] =
      AppLocalizations.of(context)!.faIconCategoryUsersPeople;
  labels[fa.FaIconCategory.weather] =
      AppLocalizations.of(context)!.faIconCategoryWeather;
  labels[fa.FaIconCategory.writing] =
      AppLocalizations.of(context)!.faIconCategoryWriting;
  assert(
    labels.length == fa.FaIconCategory.categories.length,
    "Number of localized categories don't match the number of categories in the package.",
  );
  return labels;
}
