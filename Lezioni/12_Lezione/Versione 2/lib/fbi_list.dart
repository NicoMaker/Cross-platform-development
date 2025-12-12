import "package:dio/dio.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:its_aa_pn_2025_cross_platform/fbi_api.dart";
import "package:its_aa_pn_2025_cross_platform/fbi_models.dart";
import "package:its_aa_pn_2025_cross_platform/models.dart";

final FutureProvider<List<FbiModel>> fbiListProvider =
    FutureProvider.autoDispose<List<FbiModel>>((ref) async {
      final client = Dio();
      ref.onDispose(client.close);

      final api = FbiApi(client);

      final response = await api.fetchWanted();
      final items = response.items;

      return items.map((serverModel) {
        final displayAge = switch (serverModel) {
          FbiWantedPerson(:final ageMin?, :final ageMax?) when ageMin == ageMax =>
            "$ageMin years",
          FbiWantedPerson(:final ageMin?, :final ageMax?) => "$ageMin - $ageMax years",
          FbiWantedPerson(:final ageMin?, ageMax: null) => "from $ageMin years",
          FbiWantedPerson(ageMin: null, :final ageMax?) => "up to $ageMax years",
          FbiWantedPerson(ageMin: null, ageMax: null) => "uknown age",
        };

        final displayHeight = switch (serverModel) {
          FbiWantedPerson(:final heightMin?, :final heightMax?)
              when heightMin == heightMax =>
            "$heightMin in",
          FbiWantedPerson(:final heightMin?, :final heightMax?) =>
            "height between $heightMin in $heightMax in",
          FbiWantedPerson(:final heightMin?, heightMax: null) => "from $heightMin in",
          FbiWantedPerson(heightMin: null, :final heightMax?) => "up to $heightMax in",
          FbiWantedPerson(heightMin: null, heightMax: null) => "height unknown",
        };

        final displayWeight = switch (serverModel) {
          FbiWantedPerson(:final weightMin?, :final weightMax?)
              when weightMin == weightMax =>
            "$weightMin lbs",
          FbiWantedPerson(:final weightMin?, :final weightMax?) =>
            "weight between $weightMin lbs and $weightMax lbs",
          FbiWantedPerson(weightMin: null, :final weightMax?) => "up to $weightMax lbs",
          FbiWantedPerson(:final weightMin?, weightMax: null) => "from $weightMin lbs",
          FbiWantedPerson(weightMin: null, weightMax: null) => "unkown weight",
        };

        return FbiModel(
          displayReward: serverModel.rewardText ?? "there's no reward for this person",
          displayDetails: serverModel.details ?? "FBI released no details",
          displayReason:
              serverModel.caution ?? "FBI didn't specify why this person is wanted",
          displayAge: displayAge,
          displayWeight: displayWeight,
          displayHeight: displayHeight,
        );
      }).toList();
    });
