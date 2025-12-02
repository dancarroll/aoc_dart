import 'package:aoc_shared/shared.dart';
import 'package:aoc_2024/day11/part_1.dart' as part1;
import 'package:aoc_2024/day11/part_2.dart' as part2;
import 'package:test/test.dart';

void main() {
  final day = Day.day11;

  group('sample data', tags: 'sample-data', () {
    final resources = Resources.sample;
    final file = resources.fileForCurrentYear(day);

    test('part1', () async {
      expect(await part1.calculate(file), 55312);
    });

    test('part2', () async {
      expect(await part2.calculate(file), 65601038650482);
    });
  });

  group('real data', tags: 'real-data', () {
    final resources = Resources.real;
    final file = resources.fileForCurrentYear(day);

    test('part1', () async {
      expect(await part1.calculate(file), 207683);
    });

    test('part2', () async {
      expect(await part2.calculate(file), 244782991106220);
    });
  });
}
