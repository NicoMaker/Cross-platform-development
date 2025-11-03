import 'package:its_aa_pn_2025_cross_platform/animal.dart';

Iterable<Animal> getAnimalsStartingWithL(Iterable<Animal> animals) {
  return animals.where((element) {
    return element.name.startsWith("L");
  });
}

Iterable<Animal> addAnimal(List<Animal> list, Animal animal) {
  list.add(animal);
  return list;
}

Iterable<Animal> removeAnimal(List<Animal> list, Animal animal) {
  list.remove(animal);
  return list;
}

Iterable<Animal> updateAnimalName(
  List<Animal> list,
  Animal oldAnimal,
  String newName,
) {
  list.remove(oldAnimal);
  list.add(
    Animal(
      name: newName,
      bornAt: oldAnimal.bornAt,
      ownerName: oldAnimal.ownerName,
      lastVisitAt: oldAnimal.lastVisitAt,
    ),
  );
  return list;
}