import "package:dio/dio.dart";

class RickAndMortyApi {
  const RickAndMortyApi(this.client);
  final Dio client;

  Future<RickAndMortyResponse> fetchCharacters() async {
    final result = await client.get<Json>(
      "https://rickandmortyapi.com/api/character",
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

typedef Json = Map<String, Object?>;
