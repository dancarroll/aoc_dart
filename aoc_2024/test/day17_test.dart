import 'package:aoc_2024/day17/shared.dart';
import 'package:aoc_shared/shared.dart';
import 'package:aoc_2024/day17/part_1.dart' as part1;
import 'package:aoc_2024/day17/part_2.dart' as part2;
import 'package:test/test.dart';

void main() {
  final year = Year.y2024;
  final day = Day.day17;

  group('sample data', tags: 'sample-data', () {
    final resources = Resources.sample;
    final file = resources.file(year, day);

    test('part1', () async {
      expect(await part1.calculate(file), '4,6,3,5,6,3,5,2,1,0');
    });

    test('part2', () async {
      expect(await part2.calculate(file), 29328);
    });
  });

  group('real data', tags: 'real-data', () {
    final resources = Resources.real;
    final file = resources.file(year, day);

    test('part1', () async {
      expect(await part1.calculate(file), '2,1,4,0,7,4,0,2,3');
    });

    test('part2', () async {
      expect(await part2.calculate(file), 258394985014171);
    });
  });

  group('other samples', tags: 'sample-data', () {
    // This input is given as a sample in the Part 2 test, to show the minimum
    // value necessary to have the program product itself.
    final selfOutputtingProgram = [
      'Register A: 2024',
      'Register B: 0',
      'Register C: 0',
      '',
      'Program: 0,3,5,4,3,0',
    ];

    test('validate part 1 with the part 2 example', () {
      final computer = loadDataFromLines(selfOutputtingProgram);
      computer.a = 117440;

      expect(part1.executeComputer(computer), '0,3,5,4,3,0');
    });

    test('validate part 2 with the part 2 example', () {
      // This input is given as a sample in the Part 2 test, to show the minimum
      // value necessary to have the program product itself.
      final computer = loadDataFromLines(selfOutputtingProgram);

      expect(part2.solve(computer), 117440);
    });
  });
}
