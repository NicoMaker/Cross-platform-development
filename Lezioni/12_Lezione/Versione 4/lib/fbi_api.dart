import "package:dio/dio.dart";
import "package:its_aa_pn_2025_cross_platform/fbi_models.dart";
import "package:its_aa_pn_2025_cross_platform/json.dart";

class FbiApi {
  const FbiApi(this.client);
  final Dio client;

  Future<FbiWantedResponse> fetchWanted(int page) async {
    final response = await client.get<Json>(
      "https://api.fbi.gov/wanted/v1/list",
      queryParameters: {
        "page": page,
      },
    );

    return FbiWantedResponse.fromJson(response.data!);
  }
}
