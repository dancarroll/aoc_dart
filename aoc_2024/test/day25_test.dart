import 'package:aoc_shared/shared.dart';
import 'package:aoc_2024/day25/part_1.dart' as part1;
import 'package:test/test.dart';

void main() {
  final day = Day.day25;

  group('sample data', tags: 'sample-data', () {
    final resources = Resources.sample;
    final file = resources.fileForCurrentYear(day);

    test('part1', () async {
      expect(await part1.calculate(file), 3);
    });
  });

  group('real data', tags: 'real-data', () {
    final resources = Resources.real;
    final file = resources.fileForCurrentYear(day);

    test('part1', () async {
      expect(await part1.calculate(file), 3264);
    });
  });
}
