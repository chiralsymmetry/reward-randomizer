import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_metadata/font_awesome_metadata.dart' as fa;

class IconSelectionNotifier extends StateNotifier<List<IconData>> {
  fa.IconCategory? _selectedCategory;
  String _searchTerms = "";
  late final List<IconData> _allIcons;

  IconSelectionNotifier() : super([]) {
    _allIcons = fa.FaIconCategory.categories
        .map((category) => category.icons)
        .expand((iconList) => iconList)
        .toList();
    _getIcons().then((icons) {
      state = icons;
    });
  }

  fa.IconCategory? get category => _selectedCategory;
  String get searchTerms => _searchTerms;

  Future<void> setCategory(fa.IconCategory? category) async {
    if (_selectedCategory != category) {
      _selectedCategory = category;
      state = await _getIcons();
    }
  }

  void setSearchTerms(String searchTerms) async {
    if (_searchTerms != searchTerms) {
      _searchTerms = searchTerms;
      state = await _getIcons();
    }
  }

  Set<String> _separateSearchTerms(String searchTerms) {
    if (searchTerms.isEmpty) {
      return <String>{};
    }
    // TODO: Determine whether ASCII space is a locale-independent way to separate terms.
    return searchTerms.split(" ").toSet();
  }

  bool _anySearchTermMatches(Set<String> searchTerms, String keywords) {
    final Set<String> keywordsSet = _separateSearchTerms(keywords);
    // A search term matches if it is a substring of any keyword.
    return searchTerms.any((searchTerm) =>
        keywordsSet.any((keyword) => keyword.contains(searchTerm)));
  }

  Future<List<IconData>> _getIcons() async {
    final fromCategory = _selectedCategory?.icons ?? _allIcons;
    Set<String> searchTerms = _separateSearchTerms(_searchTerms);

    final List<IconData> searchHits;
    if (searchTerms.isEmpty) {
      searchHits = fromCategory.toSet().toList();
    } else {
      final Set<IconData> nameHits = fa.faNamedMappings.entries
          .where(
            (kvp) => _anySearchTermMatches(searchTerms, kvp.key),
          )
          .map((kvp) => kvp.value)
          .toSet();

      final keywordHits = fa.searchTermMappings.entries
          .where(
            (kvp) => _anySearchTermMatches(searchTerms, kvp.key),
          )
          .map((kvp) => kvp.value)
          .expand((e) => e)
          .toSet();

      searchHits = fromCategory
          .toSet()
          .intersection(nameHits.union(keywordHits))
          .toList();
    }
    return searchHits;
  }
}

final iconSelectionProvider =
    StateNotifierProvider<IconSelectionNotifier, List<IconData>>((ref) {
  return IconSelectionNotifier();
});
