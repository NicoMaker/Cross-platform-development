class Animal {
  Animal({
    required this.name,
    required this.bornAt,
    required this.ownerName,
    required this.lastVisitAt,
  });

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

  final String name;
  final DateTime bornAt;
  final String ownerName;
  final DateTime lastVisitAt;

  int getYears() {
    final now = DateTime.now();
    return now.year - bornAt.year;
  }

  int getDaysSinceLastVisit() {
    final now = DateTime.now();
    final difference = now.difference(lastVisitAt);
    return difference.inDays;
  }
}