class CatImage {
  CatImage({
    required this.id,
    required this.url,
    required this.width,
    required this.height,
  });

  factory CatImage.fromJson(Map<String, dynamic> json) {
    return CatImage(
      id: json["id"] as String,
      url: json["url"] as String,
      width: json["width"] as int,
      height: json["height"] as int,
    );
  }

  final String id;
  final String url;
  final int width;
  final int height;

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "url": url,
      "width": width,
      "height": height,
    };
  }

  @override
  String toString() {
    return "CatImage(id: $id, url: $url, width: $width, height: $height)";
  }
}

class CatBreed {
  CatBreed({
    required this.weight,
    required this.id,
    required this.name,
    required this.temperament,
    required this.origin,
    required this.countryCodes,
    required this.countryCode,
    required this.description,
    required this.lifeSpan,
    required this.indoor,
    required this.adaptability,
    required this.affectionLevel,
    required this.childFriendly,
    required this.dogFriendly,
    required this.energyLevel,
    required this.grooming,
    required this.healthIssues,
    required this.intelligence,
    required this.sheddingLevel,
    required this.socialNeeds,
    required this.strangerFriendly,
    required this.vocalisation,
    required this.experimental,
    required this.hairless,
    required this.natural,
    required this.rare,
    required this.rex,
    required this.suppressedTail,
    required this.shortLegs,
    required this.hypoallergenic,
    this.breedGroup,
    this.cfaUrl,
    this.vetstreetUrl,
    this.vcahospitalsUrl,
    this.lap,
    this.altNames,
    this.catFriendly,
    this.bidability,
    this.wikipediaUrl,
    this.referenceImageId,
  });

  factory CatBreed.fromJson(Map<String, dynamic> json) {
    return CatBreed(
      weight: Weight.fromJson(json["weight"] as Map<String, dynamic>),
      id: json["id"] as String,
      name: json["name"] as String,
      breedGroup: json["breed_group"] as String?,
      cfaUrl: json["cfa_url"] as String?,
      vetstreetUrl: json["vetstreet_url"] as String?,
      vcahospitalsUrl: json["vcahospitals_url"] as String?,
      temperament: json["temperament"] as String,
      origin: json["origin"] as String,
      countryCodes: json["country_codes"] as String,
      countryCode: json["country_code"] as String,
      description: json["description"] as String,
      lifeSpan: json["life_span"] as String,
      indoor: json["indoor"] as int,
      lap: json["lap"] as int?,
      altNames: json["alt_names"] as String?,
      adaptability: json["adaptability"] as int,
      affectionLevel: json["affection_level"] as int,
      childFriendly: json["child_friendly"] as int,
      catFriendly: json["cat_friendly"] as int?,
      dogFriendly: json["dog_friendly"] as int,
      energyLevel: json["energy_level"] as int,
      grooming: json["grooming"] as int,
      healthIssues: json["health_issues"] as int,
      intelligence: json["intelligence"] as int,
      sheddingLevel: json["shedding_level"] as int,
      socialNeeds: json["social_needs"] as int,
      strangerFriendly: json["stranger_friendly"] as int,
      vocalisation: json["vocalisation"] as int,
      bidability: json["bidability"] as int?,
      experimental: json["experimental"] as int,
      hairless: json["hairless"] as int,
      natural: json["natural"] as int,
      rare: json["rare"] as int,
      rex: json["rex"] as int,
      suppressedTail: json["suppressed_tail"] as int,
      shortLegs: json["short_legs"] as int,
      wikipediaUrl: json["wikipedia_url"] as String?,
      hypoallergenic: json["hypoallergenic"] as int,
      referenceImageId: json["reference_image_id"] as String?,
    );
  }
  final Weight weight;
  final String id;
  final String name;
  final String? breedGroup;
  final String? cfaUrl;
  final String? vetstreetUrl;
  final String? vcahospitalsUrl;
  final String temperament;
  final String origin;
  final String countryCodes;
  final String countryCode;
  final String description;
  final String lifeSpan;
  final int indoor;
  final int? lap;
  final String? altNames;
  final int adaptability;
  final int affectionLevel;
  final int childFriendly;
  final int? catFriendly;
  final int dogFriendly;
  final int energyLevel;
  final int grooming;
  final int healthIssues;
  final int intelligence;
  final int sheddingLevel;
  final int socialNeeds;
  final int strangerFriendly;
  final int vocalisation;
  final int? bidability;
  final int experimental;
  final int hairless;
  final int natural;
  final int rare;
  final int rex;
  final int suppressedTail;
  final int shortLegs;
  final String? wikipediaUrl;
  final int hypoallergenic;
  final String? referenceImageId;

  Map<String, dynamic> toJson() {
    return {
      "weight": weight.toJson(),
      "id": id,
      "name": name,
      "breed_group": breedGroup,
      "cfa_url": cfaUrl,
      "vetstreet_url": vetstreetUrl,
      "vcahospitals_url": vcahospitalsUrl,
      "temperament": temperament,
      "origin": origin,
      "country_codes": countryCodes,
      "country_code": countryCode,
      "description": description,
      "life_span": lifeSpan,
      "indoor": indoor,
      "lap": lap,
      "alt_names": altNames,
      "adaptability": adaptability,
      "affection_level": affectionLevel,
      "child_friendly": childFriendly,
      "cat_friendly": catFriendly,
      "dog_friendly": dogFriendly,
      "energy_level": energyLevel,
      "grooming": grooming,
      "health_issues": healthIssues,
      "intelligence": intelligence,
      "shedding_level": sheddingLevel,
      "social_needs": socialNeeds,
      "stranger_friendly": strangerFriendly,
      "vocalisation": vocalisation,
      "bidability": bidability,
      "experimental": experimental,
      "hairless": hairless,
      "natural": natural,
      "rare": rare,
      "rex": rex,
      "suppressed_tail": suppressedTail,
      "short_legs": shortLegs,
      "wikipedia_url": wikipediaUrl,
      "hypoallergenic": hypoallergenic,
      "reference_image_id": referenceImageId,
    };
  }

  @override
  String toString() {
    return "CatBreed(id: $id, name: $name, origin: $origin)";
  }
}

class Weight {
  Weight({
    required this.imperial,
    required this.metric,
  });

  factory Weight.fromJson(Map<String, dynamic> json) {
    return Weight(
      imperial: json["imperial"] as String,
      metric: json["metric"] as String,
    );
  }
  final String imperial;
  final String metric;

  Map<String, dynamic> toJson() {
    return {
      "imperial": imperial,
      "metric": metric,
    };
  }

  @override
  String toString() {
    return "Weight(imperial: $imperial, metric: $metric)";
  }
}
