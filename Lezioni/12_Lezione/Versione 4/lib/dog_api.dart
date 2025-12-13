import "package:dio/dio.dart";
import "package:its_aa_pn_2025_cross_platform/dog_models.dart";
import "package:its_aa_pn_2025_cross_platform/json.dart";

class DogApi {
  const DogApi(this.client);
  final Dio client;

  Future<DogBreedsResponse> fetchBreeds() async {
    final response = await client.get<Json>(
      "https://dog.ceo/api/breeds/list/all",
    );

    return DogBreedsResponse.fromJson(response.data!);
  }

  Future<DogBreedImagesResponse> fetchImages(String breed) async {
    final response = await client.get<Json>(
      "https://dog.ceo/api/breed/$breed/images",
    );

    return DogBreedImagesResponse.fromJson(response.data!);
  }
}
