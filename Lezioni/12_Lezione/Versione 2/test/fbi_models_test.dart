import "dart:convert";
import "dart:io";

import "package:flutter_test/flutter_test.dart";
import "package:its_aa_pn_2025_cross_platform/fbi_models.dart";

void main() {
  test("Fbi models from json actually work on the server response", () {
    final file = File("./request_example.json");
    final content = file.readAsStringSync();
    final json = jsonDecode(content)! as Map<String, Object?>;

    expect(() => FbiWantedResponse.fromJson(json), returnsNormally);
  });
}
