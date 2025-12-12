import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:its_aa_pn_2025_cross_platform/models.dart";

final NotifierProvider<SavedFbiList, List<FbiModel>> savedFbiListProvider =
    NotifierProvider.autoDispose<SavedFbiList, List<FbiModel>>(SavedFbiList.new);

class SavedFbiList extends Notifier<List<FbiModel>> {
  @override
  List<FbiModel> build() {
    return [];
  }

  void addFavorite(FbiModel toBeSaved) {
    state.add(toBeSaved);
    ref.notifyListeners();
  }

  void removeFavorite(FbiModel toBeRemoved) {
    state.remove(toBeRemoved);
    ref.notifyListeners();
  }
}
