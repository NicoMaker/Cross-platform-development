// episode_api.dart

import "package:dio/dio.dart";

// Alias per la mappa JSON
typedef Json = Map<String, Object?>;

class EpisodeApi {
  const EpisodeApi(this.client);
  final Dio client;

  Future<EpisodeResponse> fetchEpisodes() async {
    final result = await client.get<Json>(
      "https://rickandmortyapi.com/api/episode",
    );
    return EpisodeResponse.fromJson(result.data!);
  }
}

class EpisodeResponse {
  const EpisodeResponse({
    required this.info,
    required this.results,
  });

  factory EpisodeResponse.fromJson(Json json) {
    return EpisodeResponse(
      info: ResponseInfo.fromJson(json["info"]! as Json),
      results: (json["results"]! as List<dynamic>)
          .map((e) => Episode.fromJson(e as Json))
          .toList(),
    );
  }

  final ResponseInfo info;
  final List<Episode> results;
}

class ResponseInfo {
  const ResponseInfo({
    required this.count,
    required this.pages,
    this.next,
    this.prev,
  });

  factory ResponseInfo.fromJson(Json json) {
    return ResponseInfo(
      count: json["count"]! as int,
      pages: json["pages"]! as int,
      next: json["next"] as String?,
      prev: json["prev"] as String?,
    );
  }

  final int count;
  final int pages;
  final String? next;
  final String? prev;
}

class Episode {
  const Episode({
    required this.id,
    required this.name,
    required this.airDate,
    required this.episode,
    required this.characters,
    required this.url,
    required this.created,
  });

  factory Episode.fromJson(Json json) {
    return Episode(
      id: json["id"]! as int,
      name: json["name"]! as String,
      airDate: json["air_date"]! as String,
      episode: json["episode"]! as String,
      characters: (json["characters"]! as List<dynamic>).cast<String>(),
      url: json["url"]! as String,
      created: json["created"]! as String,
    );
  }

  final int id;
  final String name;
  final String airDate;
  final String episode;
  final List<String> characters;
  final String url;
  final String created;
}