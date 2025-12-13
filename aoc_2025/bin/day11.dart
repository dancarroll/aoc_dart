import 'package:aoc_2025/day11/part_1.dart' as part1;
import 'package:aoc_2025/day11/part_2.dart' as part2;
import 'package:aoc_shared/shared.dart';

Future<void> main(List<String> arguments) async {
  await runDay(
    year: Year.y2025,
    day: Day.day11,
    part1: part1.calculate,
    part2: part2.calculate,
    fileSuffix: (part, resourceType) =>
        (resourceType == ResourceType.sample && part == Part.part2)
        ? '_part2'
        : '',
  );
}
