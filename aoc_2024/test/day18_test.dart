import 'package:aoc_shared/shared.dart';
import 'package:aoc_2024/day18/part_1.dart' as part1;
import 'package:aoc_2024/day18/part_2.dart' as part2;
import 'package:test/test.dart';

void main() {
  final day = Day.day18;

  group('sample data', tags: 'sample-data', () {
    final resources = Resources.sample;
    final file = resources.file(day);

    test('part1', () async {
      expect(await part1.calculate(file), 22);
    });

    test('part2', () async {
      expect(await part2.calculate(file), '6,1');
    });
  });

  group('real data', tags: 'real-data', () {
    final resources = Resources.real;
    final file = resources.file(day);

    test('part1', () async {
      expect(await part1.calculate(file), 292);
    });

    test('part2', () async {
      expect(await part2.calculate(file), '58,44');
    });
  });
}
