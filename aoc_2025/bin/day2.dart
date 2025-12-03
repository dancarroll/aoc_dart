import 'package:aoc_2025/day2/part_1.dart' as part1;
import 'package:aoc_2025/day2/part_2.dart' as part2;
import 'package:aoc_2025/day2/part_2regex.dart' as part_2regex;
import 'package:aoc_shared/shared.dart';

Future<void> main(List<String> arguments) async {
  await runDay(
    year: Year.y2025,
    day: Day.day2,
    part1: part1.calculate,
    part2: part2.calculate,
    additional: [(description: '2 (regex)', function: part_2regex.calculate)],
  );
}
