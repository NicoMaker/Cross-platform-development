import 'package:its_aa_pn_2025_cross_platform/animal.dart';
import 'package:its_aa_pn_2025_cross_platform/marano.dart';

void main(List<String> arguments) {
  final fido = Animal.register(
    petName: "Fido",
    bornAt: DateTime(2020, 5, 20),
    ownerName: fullName("Denis", "Mascherin"),
  );
  final luna = Animal.register(
    petName: "Luna",
    bornAt: DateTime(2014, 4, 30),
    ownerName: "Luna",
  );

  final snoopy = Animal.register(
    petName: "Snoopy",
    bornAt: DateTime(2012, 1, 15),
    ownerName: "Laura",
  );

  final list = [fido, luna, snoopy];

  for(final animal in list) {
    print("il tuo animale si chiama: ${animal.name}");
    print("il suo padrone è: ${animal.ownerName}");
    print("ha ${animal.getYears()} anni");
    // print("l'ho visitato l'ultima volta ${animal.getDaysSinceLastVisit(luna)} giorni fa");
  }
  
  print("il tuo animale si chiama: ${fido.name}");
  print("il suo padrone è: ${fido.ownerName}");
  print("ha ${fido.getYears()} anni");
  
  // Questa è la riga corretta
  print("l'ho visitato l'ultima volta ${fido.getDaysSinceLastVisit(fido)} giorni fa");
}