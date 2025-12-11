import "package:collection/collection.dart";

class Exercise {
  Exercise({
    required this.name,
    required this.score,
    required this.submittedAt,
  }) : assert(score >= 0 && score <= 100, "il voto non ha senso se negativo o sopra 100");
  String name;
  int score;
  DateTime submittedAt;

  bool get isValid {
    return score >= 0 && score <= 100;
  }

  bool get isPassed {
    return score >= 60;
  }
}

List<Exercise> passedOnly(List<Exercise> input) {
  return input.where((element) => element.isPassed).toList();
}

double? averageScore(List<Exercise> input) {
  if (input.isEmpty) return null;
  final sum = input.map((e) => e.score).sum;
  return sum / input.length;
}

String bestStudent(List<Exercise> input) {
  assert(input.isNotEmpty, "input list must not be empty");
  return input.reduce((accumulator, current) {
    if (current.score > accumulator.score) {
      return current;
    } else {
      return accumulator;
    }
  }).name;
}
