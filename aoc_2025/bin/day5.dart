import 'package:aoc_2025/day5/part_1.dart' as part1;
import 'package:aoc_2025/day5/part_2.dart' as part2;
import 'package:aoc_shared/shared.dart';

Future<void> main(List<String> arguments) async {
  await runDay(
    year: Year.y2025,
    day: Day.day5,
    part1: part1.calculate,
    part2: part2.calculate,
  );
}
