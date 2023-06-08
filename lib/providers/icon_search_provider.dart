import 'package:flutter_riverpod/flutter_riverpod.dart';

class IconSearchNotifier extends StateNotifier<String> {
  IconSearchNotifier() : super("");

  void setSearchTerms(String searchTerms) {
    if (searchTerms != state) {
      state = searchTerms;
    }
  }
}

final iconSearchProvider = StateNotifierProvider<IconSearchNotifier, String>(
  (ref) => IconSearchNotifier(),
);
