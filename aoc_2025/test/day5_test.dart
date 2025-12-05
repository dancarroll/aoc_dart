import 'package:aoc_shared/shared.dart';
import 'package:aoc_2025/day5/part_1.dart' as part1;
import 'package:aoc_2025/day5/part_2.dart' as part2;
import 'package:test/test.dart';

void main() {
  final year = Year.y2025;
  final day = Day.day5;

  group('sample data', tags: 'sample-data', () {
    final resources = Resources.sample;
    final file = resources.file(year, day);

    test('part1', () async {
      expect(await part1.calculate(file), 3);
    });

    test('part2', () async {
      expect(await part2.calculate(file), 14);
    });
  });

  group('real data', tags: 'real-data', () {
    final resources = Resources.real;
    final file = resources.file(year, day);

    test('part1', () async {
      expect(await part1.calculate(file), 690);
    });

    test('part2', () async {
      expect(await part2.calculate(file), 344323629240733);
    });
  });
}
