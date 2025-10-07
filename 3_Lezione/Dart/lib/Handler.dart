import 'package:its_aa_pn_2025_cross_platform/animal.dart';
import 'package:its_aa_pn_2025_cross_platform/person.dart';

class Handler {
  List<Animal> animals = [];

  List<Person> get people {
    return animals.map((animal) {
      return animal.owner;
    }).toList();
  }
}