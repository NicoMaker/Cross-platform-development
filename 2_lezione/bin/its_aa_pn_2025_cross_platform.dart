import 'package:its_aa_pn_2025_cross_platform/animal.dart';

void main(List<String> arguments) {
  final leo = Animal.register(
    petName: "Leo",
    bornAt: DateTime(2006, 01, 26),
    ownerName: "Luca",
  );
  final luna = Animal.register(
    petName: "Luna",
    bornAt: DateTime(2014, 04, 30),
    ownerName: "Luna",
  );
  final renee = Animal.register(
    petName: "Renée",
    bornAt: DateTime(2010, 03, 29),
    ownerName: "Francesca",
  );

  final list = [leo, luna, renee];

  print("\n");
  print("\n");
  for (final animal in list) {
    print("il tuo animale si chiama: ${animal.name}");
    print("il suo padrone è ${animal.ownerName}");
    print("ha ${animal.getYears()} anni");
    print(
      "l'ho visitato l'ultima volta ${animal.getDaysSinceLastVisit()} giorni fa",
    );

    print("\n");
  }
  print("\n");
}
