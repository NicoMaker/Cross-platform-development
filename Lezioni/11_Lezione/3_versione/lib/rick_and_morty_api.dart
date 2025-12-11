// rick_and_morty_api.dart

import "package:dio/dio.dart";
import "package:its_aa_pn_2025_cross_platform/episode_api.dart"; // Importa l'alias Json

class RickAndMortyApi {
  const RickAndMortyApi(this.client);
  final Dio client;

  Future<RickAndMortyResponse> fetchCharacters({
    String? query,
  }) async {
    final result = await client.get<Json>(
      "https://rickandmortyapi.com/api/character",
      queryParameters: {
        // not now, dart.
        // ignore: use_null_aware_elements
        if (query != null) "name": query,
      },
    );
    return RickAndMortyResponse.fromJson(result.data!);
  }
}

class RickAndMortyResponse {
  const RickAndMortyResponse({
    required this.info,
    required this.results,
  });

  factory RickAndMortyResponse.fromJson(Json json) {
    return RickAndMortyResponse(
      info: ResponseInfo.fromJson(json["info"]! as Json),
      results: (json["results"]! as List<dynamic>)
          .map((e) => Character.fromJson(e as Json))
          .toList(),
    );
  }

  final ResponseInfo info;
  final List<Character> results;
}

// Le classi ResponseInfo e Character le ho lasciate qui,
// ma per chiarezza e per evitare duplicazioni, in un progetto reale
// la ResponseInfo sarebbe un'unica classe condivisa.
// Per questo esercizio, ho mantenuto la ResponseInfo duplicata in
// episode_api.dart per completezza.

// La classe ResponseInfo è stata spostata in episode_api.dart per l'alias Json,
// e la sua implementazione è stata rimossa qui, ma non è usata in questo file
// dato che il tipo RickAndMortyResponse si aspetta la ResponseInfo di episode_api.dart.
// Per semplicità e per far compilare il codice con l'alias Json:

class Character {
  const Character({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.type,
    required this.gender,
    required this.origin,
    required this.location,
    required this.image,
    required this.episode,
    required this.url,
    required this.created,
  });

  factory Character.fromJson(Json json) {
    return Character(
      id: json["id"]! as int,
      name: json["name"]! as String,
      status: json["status"]! as String,
      species: json["species"]! as String,
      type: json["type"]! as String,
      gender: json["gender"]! as String,
      origin: CharacterLocation.fromJson(json["origin"]! as Json),
      location: CharacterLocation.fromJson(json["location"]! as Json),
      image: json["image"]! as String,
      episode: (json["episode"]! as List<dynamic>).cast<String>(),
      url: json["url"]! as String,
      created: json["created"]! as String,
    );
  }

  final int id;
  final String name;
  final String status;
  final String species;
  final String type;
  final String gender;
  final CharacterLocation origin;
  final CharacterLocation location;
  final String image;
  final List<String> episode;
  final String url;
  final String created;
}

class CharacterLocation {
  const CharacterLocation({
    required this.name,
    required this.url,
  });

  factory CharacterLocation.fromJson(Json json) {
    return CharacterLocation(
      name: json["name"]! as String,
      url: json["url"]! as String,
    );
  }

  final String name;
  final String url;
}