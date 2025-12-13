/// Response model for the FBI Wanted API
class FbiWantedResponse {
  FbiWantedResponse({
    required this.total,
    required this.items,
    required this.page,
  });

  factory FbiWantedResponse.fromJson(Map<String, dynamic> json) {
    return FbiWantedResponse(
      total: json["total"] as int? ?? 0,
      items:
          (json["items"] as List<dynamic>?)
              ?.map((e) => FbiWantedPerson.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      page: json["page"] as int? ?? 1,
    );
  }
  final int total;
  final List<FbiWantedPerson> items;
  final int page;
}

/// Model for an image from the FBI API
class FbiImage {
  FbiImage({
    this.caption,
    this.original,
    this.large,
    this.thumb,
  });

  factory FbiImage.fromJson(Map<String, dynamic> json) {
    return FbiImage(
      caption: json["caption"] as String?,
      original: json["original"] as String?,
      large: json["large"] as String?,
      thumb: json["thumb"] as String?,
    );
  }

  final String? caption;
  final String? original;
  final String? large;
  final String? thumb;
}

/// Model for an individual wanted person from the FBI API
class FbiWantedPerson {
  FbiWantedPerson({
    this.title,
    this.aliases,
    this.images,
    this.rewardMin,
    this.rewardMax,
    this.rewardText,
    this.ageMin,
    this.ageMax,
    this.ageRange,
    this.weight,
    this.weightMin,
    this.weightMax,
    this.heightMin,
    this.heightMax,
    this.details,
    this.caution,
  });

  factory FbiWantedPerson.fromJson(Map<String, dynamic> json) {
    return FbiWantedPerson(
      title: json["title"] as String?,
      aliases: (json["aliases"] as List<dynamic>?)?.cast<String>(),
      images: (json["images"] as List<dynamic>?)
          ?.map((e) => FbiImage.fromJson(e as Map<String, dynamic>))
          .toList(),
      rewardMin: json["reward_min"] as int?,
      rewardMax: json["reward_max"] as int?,
      rewardText: json["reward_text"] as String?,
      ageMin: json["age_min"] as int?,
      ageMax: json["age_max"] as int?,
      ageRange: json["age_range"] as String?,
      weight: json["weight"] as String?,
      weightMin: json["weight_min"] as int?,
      weightMax: json["weight_max"] as int?,
      heightMin: json["height_min"] as int?,
      heightMax: json["height_max"] as int?,
      details: json["details"] as String?,
      caution: json["caution"] as String?,
    );
  }

  // Name fields
  final String? title;
  final List<String>? aliases;

  // Image metadata
  final List<FbiImage>? images;

  // Reward fields
  final int? rewardMin;
  final int? rewardMax;
  final String? rewardText;

  // Age fields
  final int? ageMin;
  final int? ageMax;
  final String? ageRange;

  // Weight fields (in pounds)
  final String? weight;
  final int? weightMin;
  final int? weightMax;

  // Height fields (in inches)
  final int? heightMin;
  final int? heightMax;

  // Details and caution
  final String? details;
  final String? caution;

  /// Estimated reward (returns max if available, otherwise min)
  int? get estimatedReward => rewardMax ?? rewardMin;

  /// Estimated age (average of min and max, or parses age_range)
  double? get estimatedAge {
    if (ageMin != null && ageMax != null) {
      return (ageMin! + ageMax!) / 2;
    }
    if (ageMin != null) return ageMin!.toDouble();
    if (ageMax != null) return ageMax!.toDouble();
    return null;
  }

  /// Estimated weight in pounds (average of min and max)
  double? get estimatedWeight {
    if (weightMin != null && weightMax != null) {
      return (weightMin! + weightMax!) / 2;
    }
    if (weightMin != null) return weightMin!.toDouble();
    if (weightMax != null) return weightMax!.toDouble();
    return null;
  }

  /// Estimated height in inches (average of min and max)
  double? get estimatedHeight {
    if (heightMin != null && heightMax != null) {
      return (heightMin! + heightMax!) / 2;
    }
    if (heightMin != null) return heightMin!.toDouble();
    if (heightMax != null) return heightMax!.toDouble();
    return null;
  }
}
