import 'package:aoc_shared/shared.dart';
import 'package:aoc_2024/day20/part_1.dart' as part1;
import 'package:aoc_2024/day20/part_2.dart' as part2;
import 'package:test/test.dart';

void main() {
  final day = Day.day20;

  group('sample data', tags: 'sample-data', () {
    final resources = Resources.sample;
    final file = resources.fileForCurrentYear(day);

    test('part1', () async {
      expect(await part1.calculate(file), 5);
    });

    test('part2', () async {
      expect(await part2.calculate(file), 285);
    });
  });

  group('real data', tags: 'real-data', () {
    final resources = Resources.real;
    final file = resources.fileForCurrentYear(day);

    test('part1', () async {
      expect(await part1.calculate(file), 1518);
    });

    test('part2', () async {
      expect(await part2.calculate(file), 1032257);
    });
  });
}
