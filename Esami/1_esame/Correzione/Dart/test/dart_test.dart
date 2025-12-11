import "package:flutter_test/flutter_test.dart";
import "package:its_aa_pn_2025_cross_platform/dart.dart";

void main() {
  group("Exercise class", () {
    test("should have name, score, and submittedAt fields", () {
      final now = DateTime.now();
      final exercise = Exercise(
        name: "Mario Rossi",
        score: 85,
        submittedAt: now,
      );

      expect(exercise.name, "Mario Rossi");
      expect(exercise.score, 85);
      expect(exercise.submittedAt, now);
    });

    test("score should be between 0 and 100", () {
      final exercise1 = Exercise(
        name: "Test",
        score: 0,
        submittedAt: DateTime.now(),
      );
      final exercise2 = Exercise(
        name: "Test",
        score: 100,
        submittedAt: DateTime.now(),
      );

      expect(exercise1.score, 0);
      expect(exercise2.score, 100);
    });
  });

  // 2. isPassed getter
  group("isPassed", () {
    test("should return true when score is exactly 60", () {
      final exercise = Exercise(
        name: "Test",
        score: 60,
        submittedAt: DateTime.now(),
      );

      expect(exercise.isPassed, true);
    });

    test("should return true when score is above 60", () {
      final exercise = Exercise(
        name: "Test",
        score: 85,
        submittedAt: DateTime.now(),
      );

      expect(exercise.isPassed, true);
    });

    test("should return false when score is below 60", () {
      final exercise = Exercise(
        name: "Test",
        score: 59,
        submittedAt: DateTime.now(),
      );

      expect(exercise.isPassed, false);
    });
  });

  // 3. passedOnly function
  group("passedOnly", () {
    test("should return only exercises with score >= 60", () {
      final exercises = [
        Exercise(name: "Mario", score: 70, submittedAt: DateTime.now()),
        Exercise(name: "Luigi", score: 50, submittedAt: DateTime.now()),
        Exercise(name: "Peach", score: 60, submittedAt: DateTime.now()),
        Exercise(name: "Toad", score: 45, submittedAt: DateTime.now()),
      ];

      final passed = passedOnly(exercises);

      expect(passed.length, 2);
      final [mario, peach] = passed;
      expect(mario.name, "Mario");
      expect(mario.score, 70);
      expect(peach.name, "Peach");
      expect(peach.score, 60);
    });

    test("should return empty list when no exercises passed", () {
      final exercises = [
        Exercise(name: "Mario", score: 30, submittedAt: DateTime.now()),
        Exercise(name: "Luigi", score: 50, submittedAt: DateTime.now()),
      ];

      final passed = passedOnly(exercises);

      expect(passed, isEmpty);
    });

    test("should return all exercises when all passed", () {
      final exercises = [
        Exercise(name: "Mario", score: 70, submittedAt: DateTime.now()),
        Exercise(name: "Luigi", score: 80, submittedAt: DateTime.now()),
      ];

      final passed = passedOnly(exercises);

      expect(passed.length, 2);
    });
  });

  // 4. averageScore function
  group("averageScore", () {
    test("should calculate the average score of exercises", () {
      final exercises = [
        Exercise(name: "Mario", score: 70, submittedAt: DateTime.now()),
        Exercise(name: "Luigi", score: 80, submittedAt: DateTime.now()),
        Exercise(name: "Peach", score: 90, submittedAt: DateTime.now()),
      ];

      final average = averageScore(exercises);

      expect(average, 80.0);
    });

    test("should return correct average for single exercise", () {
      final exercises = [
        Exercise(name: "Mario", score: 75, submittedAt: DateTime.now()),
      ];

      final average = averageScore(exercises);

      expect(average, 75.0);
    });

    test("should handle decimal averages", () {
      final exercises = [
        Exercise(name: "Mario", score: 70, submittedAt: DateTime.now()),
        Exercise(name: "Luigi", score: 75, submittedAt: DateTime.now()),
      ];

      final average = averageScore(exercises);

      expect(average, 72.5);
    });

    test("returns null if no exercises are passed", () {
      final exercises = <Exercise>[];

      final average = averageScore(exercises);

      expect(average, isNull);
    });
  });

  // 5. bestStudent function
  group("bestStudent", () {
    test("should return the name of the student with highest score", () {
      final exercises = [
        Exercise(name: "Mario", score: 70, submittedAt: DateTime.now()),
        Exercise(name: "Luigi", score: 95, submittedAt: DateTime.now()),
        Exercise(name: "Peach", score: 80, submittedAt: DateTime.now()),
      ];

      final best = bestStudent(exercises);

      expect(best, "Luigi");
    });

    test("should return the name when only one student", () {
      final exercises = [
        Exercise(name: "Mario", score: 70, submittedAt: DateTime.now()),
      ];

      final best = bestStudent(exercises);

      expect(best, "Mario");
    });

    test("should return first student with highest score when tie", () {
      final exercises = [
        Exercise(name: "Mario", score: 90, submittedAt: DateTime.now()),
        Exercise(name: "Luigi", score: 90, submittedAt: DateTime.now()),
      ];

      final best = bestStudent(exercises);

      expect(best, "Mario");
    });
  });
}
