import 'package:aoc_shared/shared.dart';
import 'package:aoc_2024/day14/part_1.dart' as part1;
import 'package:aoc_2024/day14/part_2.dart' as part2;
import 'package:test/test.dart';

void main() {
  final day = Day.day14;

  group('sample data', tags: 'sample-data', () {
    final resources = Resources.sample;
    final file = resources.fileForCurrentYear(day);

    test('part1', () async {
      expect(await part1.calculate(file), 12);
    });

    // The sample data doesn't work for part 2.
  });

  group('real data', tags: 'real-data', () {
    final resources = Resources.real;
    final file = resources.fileForCurrentYear(day);

    test('part1', () async {
      expect(await part1.calculate(file), 228410028);
    });

    test('part2', () async {
      expect(await part2.calculate(file), 8258);
    });
  });
}
