import 'package:its_aa_pn_2025_cross_platform/animal.dart';

class Person {
  Person({
    required this.firstName,
    required this.lastName,
    required this.birthDate,
    required this.animals,
  });
  String firstName;
  String lastName;
  DateTime birthDate;
  List<Animal> animals;
}