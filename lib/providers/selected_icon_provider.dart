import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_metadata/font_awesome_metadata.dart';

const FaIcon kDefaultIcon = FaIcon(FontAwesomeIcons.question);

class SelectedIconNotifier extends StateNotifier<FaIcon> {
  SelectedIconNotifier() : super(kDefaultIcon);

  void setIcon(FaIcon icon) {
    if (icon != state) {
      state = icon;
    }
  }

  void setIconFromData(int codePoint, String fontFamily, String fontPackage) {
    if (state.icon == null ||
        (codePoint != state.icon!.codePoint ||
            fontFamily != state.icon!.fontFamily ||
            fontPackage != state.icon!.fontPackage)) {
      state = FaIcon(
        IconData(
          codePoint,
          fontFamily: fontFamily,
          fontPackage: fontPackage,
        ),
      );
    }
  }
}

final selectedIconProvider =
    StateNotifierProvider<SelectedIconNotifier, FaIcon>(
  (ref) => SelectedIconNotifier(),
);
