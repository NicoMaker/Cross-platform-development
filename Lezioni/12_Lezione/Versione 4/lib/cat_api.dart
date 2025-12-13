import "package:dio/dio.dart";
import "package:its_aa_pn_2025_cross_platform/cat_models.dart";

class CatApi {
  const CatApi(this.client);
  final Dio client;

  Future<List<CatBreed>> fetchBreeds() async {
    final response = await client.get<List<Object?>>(
      "https://api.thecatapi.com/v1/breeds",
    );

    return response.data!
        .map((e) => e!)
        .map((e) => e as Map<String, Object?>)
        .map(CatBreed.fromJson)
        .toList();
  }

  Future<List<CatImage>> fetchImagesByBreed(String breed) async {
    final response = await client.get<List<Object?>>(
      "https://api.thecatapi.com/v1/images/search",
      queryParameters: {
        "breed_id": breed,
        "limit": 10,
      },
    );

    return response.data!
        .map((e) => e!)
        .map((e) => e as Map<String, Object?>)
        .map(CatImage.fromJson)
        .toList();
  }
}
