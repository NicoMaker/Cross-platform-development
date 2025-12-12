import "package:dio/dio.dart";
import "package:its_aa_pn_2025_cross_platform/fbi_models.dart";
import "package:its_aa_pn_2025_cross_platform/json.dart";

class FbiApi {
  const FbiApi(this.client);
  final Dio client;

  Future<FbiWantedResponse> fetchWanted() async {
    final response = await client.get<Json>(
      "https://api.fbi.gov/wanted/v1/list",
    );

    return FbiWantedResponse.fromJson(response.data!);
  }
}
