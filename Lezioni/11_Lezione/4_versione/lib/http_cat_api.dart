// http_cat_api.dart

import 'package:dio/dio.dart';

class HttpCatApi {
  const HttpCatApi(this.client);
  final Dio client;

  /// Fetches the raw image bytes for a given HTTP status code.
  /// The API URL is https://http.cat/[statusCode]
  Future<List<int>> fetchCatImage(int statusCode) async {
    final response = await client.get<List<int>>(
      "https://http.cat/$statusCode",
      options: Options(
        responseType: ResponseType.bytes, // Richiediamo bytes anziché JSON
      ),
    );
    if (response.data == null) {
      throw Exception("Impossibile caricare l'immagine del gatto per lo stato $statusCode");
    }
    return response.data!;
  }
}