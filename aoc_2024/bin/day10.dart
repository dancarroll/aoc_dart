import 'package:aoc_shared/shared.dart';
import 'package:aoc_2024/day10/part_1.dart' as part1;
import 'package:aoc_2024/day10/part_2.dart' as part2;

Future<void> main(List<String> arguments) async {
  await runDay(
    year: Year.y2024,
    day: Day.day10,
    part1: part1.calculate,
    part2: part2.calculate,
  );
}
