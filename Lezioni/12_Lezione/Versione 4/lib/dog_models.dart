/// Response from the Dog CEO API for listing all breeds
/// https://dog.ceo/api/breeds/list/all
class DogBreedsResponse {
  const DogBreedsResponse({
    required this.message,
    required this.status,
  });

  factory DogBreedsResponse.fromJson(Map<String, dynamic> json) {
    final messageJson = json["message"] as Map<String, dynamic>;
    final message = messageJson.map(
      (key, value) => MapEntry(
        key,
        (value as List<dynamic>).map((e) => e as String).toList(),
      ),
    );

    return DogBreedsResponse(
      message: message,
      status: json["status"] as String,
    );
  }
  final Map<String, List<String>> message;
  final String status;

  Map<String, dynamic> toJson() {
    return {
      "message": message,
      "status": status,
    };
  }

  /// Returns a list of all breed names (main breeds only)
  List<String> get breeds => message.keys.toList();

  /// Returns all sub-breeds for a given breed
  List<String> getSubBreeds(String breed) => message[breed] ?? [];

  @override
  String toString() => "DogBreedsResponse(status: $status, breeds: ${breeds.length})";
}

/// Response from the Dog CEO API for breed images
/// https://dog.ceo/api/breed/{breed}/images
class DogBreedImagesResponse {
  const DogBreedImagesResponse({
    required this.message,
    required this.status,
  });

  factory DogBreedImagesResponse.fromJson(Map<String, dynamic> json) {
    final messageJson = json["message"] as List<dynamic>;
    final message = messageJson.map((e) => e as String).toList();

    return DogBreedImagesResponse(
      message: message,
      status: json["status"] as String,
    );
  }

  /// List of image URLs for the breed
  final List<String> message;
  final String status;

  Map<String, dynamic> toJson() {
    return {
      "message": message,
      "status": status,
    };
  }

  /// Returns the list of image URLs
  List<String> get imageUrls => message;

  /// Returns the number of images
  int get count => message.length;

  @override
  String toString() => "DogBreedImagesResponse(status: $status, images: $count)";
}
