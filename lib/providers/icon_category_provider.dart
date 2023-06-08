import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_metadata/font_awesome_metadata.dart' as fa;

class IconCategoryNotifier extends StateNotifier<fa.IconCategory?> {
  IconCategoryNotifier() : super(null);

  void setCategory(fa.IconCategory? category) {
    if (category != state) {
      state = category;
    }
  }
}

final iconCategoryProvider =
    StateNotifierProvider<IconCategoryNotifier, fa.IconCategory?>(
  (ref) => IconCategoryNotifier(),
);
