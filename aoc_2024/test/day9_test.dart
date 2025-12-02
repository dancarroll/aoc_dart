import 'package:aoc_shared/shared.dart';
import 'package:aoc_2024/day9/part_1.dart' as part1;
import 'package:aoc_2024/day9/part_2.dart' as part2;
import 'package:test/test.dart';

void main() {
  final year = Year.y2024;
  final day = Day.day9;

  group('sample data', tags: 'sample-data', () {
    final resources = Resources.sample;
    final file = resources.file(year, day);

    test('part1', () async {
      expect(await part1.calculate(file), 1928);
    });

    test('part2', () async {
      expect(await part2.calculate(file), 2858);
    });
  });

  group('real data', tags: 'real-data', () {
    final resources = Resources.real;
    final file = resources.file(year, day);

    test('part1', () async {
      expect(await part1.calculate(file), 6259790630969);
    });

    test('part2', () async {
      expect(await part2.calculate(file), 6289564433984);
    });
  });
}
