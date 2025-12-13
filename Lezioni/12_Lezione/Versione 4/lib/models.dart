import "package:collection/collection.dart";

class FbiModel {
  const FbiModel({
    required this.displayReward,
    required this.displayDetails,
    required this.displayReason,
    required this.displayAge,
    required this.displayWeight,
    required this.displayHeight,
    required this.images,
  });
  final String displayReward;
  final String displayDetails;
  final String displayReason;
  final String displayAge;
  final String displayWeight;
  final String displayHeight;
  final List<String> images;

  String? get previewImage {
    if (images.isEmpty) return null;
    return images.sample(1).single;
  }
}
