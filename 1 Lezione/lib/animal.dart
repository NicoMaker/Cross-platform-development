class Animal {
  // Le proprietà della classe devono essere dichiarate qui
  final String name;
  final DateTime bornAt;
  final String ownerName;
  final DateTime lastVisitAt;

  // Costruttore principale
  Animal({
    required this.name,
    required this.bornAt,
    required this.ownerName,
    required this.lastVisitAt,
  });

  // Costruttore di factory
  factory Animal.register({
    required String petName,
    required DateTime bornAt,
    required String ownerName,
  }) {
    return Animal(
      name: petName,
      bornAt: bornAt,
      ownerName: ownerName,
      lastVisitAt: DateTime.now(),
    );
  }

  // Metodi della classe
  int getYears() {
    final now = DateTime.now();
    final difference = now.difference(this.bornAt);
    return now.year - bornAt.year;
  }

  int getDaysSinceLastVisit(Animal animal) {
    final now = DateTime.now();
    final difference = now.difference(animal.lastVisitAt);
    return difference.inDays;
  }
}
