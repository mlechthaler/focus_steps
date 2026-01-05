import 'package:flutter_test/flutter_test.dart';
import 'package:focus_steps/utils/id_generator.dart';

void main() {
  group('IdGenerator', () {
    test('generate returns a non-empty string', () {
      final id = IdGenerator.generate();
      expect(id, isNotEmpty);
    });

    test('generate returns unique IDs', () {
      final id1 = IdGenerator.generate();
      // Add a small delay to ensure different timestamps
      Future.delayed(const Duration(milliseconds: 1));
      final id2 = IdGenerator.generate();

      expect(id1, isNot(equals(id2)));
    });

    test('generate returns numeric string (timestamp)', () {
      final id = IdGenerator.generate();
      final parsed = int.tryParse(id);

      expect(parsed, isNotNull);
      expect(parsed, greaterThan(0));
    });
  });
}
