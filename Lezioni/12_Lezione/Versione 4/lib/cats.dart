import "package:dio/dio.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:its_aa_pn_2025_cross_platform/cat_api.dart";
import "package:its_aa_pn_2025_cross_platform/cat_models.dart";
import "package:talker_dio_logger/talker_dio_logger_interceptor.dart";

final dioProvider = Provider.autoDispose<Dio>((ref) {
  final client = Dio();
  ref.onDispose(client.close);

  client.interceptors.add(TalkerDioLogger());

  return client;
});

final catBreedsProvider = FutureProvider.autoDispose<List<CatBreed>>((ref) {
  final dio = ref.watch(dioProvider);
  final api = CatApi(dio);
  return api.fetchBreeds();
});

final catImagesByBreedProvider = FutureProvider.autoDispose
    .family<List<CatImage>, String>((ref, breedId) {
      final dio = ref.watch(dioProvider);
      final api = CatApi(dio);
      return api.fetchImagesByBreed(breedId);
    });

final catFavoriteBreedsProvider =
    NotifierProvider.autoDispose<CatFavoriteBreedsNotifier, List<CatBreed>>(
      CatFavoriteBreedsNotifier.new,
    );

class CatFavoriteBreedsNotifier extends Notifier<List<CatBreed>> {
  @override
  List<CatBreed> build() {
    return [];
  }

  void toggleFavorite(CatBreed breed) {
    final index = state.indexOf(breed);
    if (index == -1) {
      state.add(breed);
    } else {
      state.removeAt(index);
    }
    ref.notifyListeners();
  }
}
