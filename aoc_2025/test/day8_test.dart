import 'package:aoc_shared/shared.dart';
import 'package:aoc_2025/day8/part_1.dart' as part1;
import 'package:aoc_2025/day8/part_2.dart' as part2;
import 'package:test/test.dart';

void main() {
  final year = Year.y2025;
  final day = Day.day8;

  group('sample data', tags: 'sample-data', () {
    final resources = Resources.sample;
    final file = resources.file(year, day);

    test('part1', () async {
      expect(await part1.calculate(file), 40);
    });

    test('part2', () async {
      expect(await part2.calculate(file), 25272);
    });
  });

  group('real data', tags: 'real-data', () {
    final resources = Resources.real;
    final file = resources.file(year, day);

    test('part1', () async {
      expect(await part1.calculate(file), 122636);
    });

    test('part2', () async {
      expect(await part2.calculate(file), 9271575747);
    });
  });
}
