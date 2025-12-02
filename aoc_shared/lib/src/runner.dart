import 'dart:io';

import 'resources.dart';

typedef DayFunction = Future<dynamic> Function(File);

typedef AdditionalPart = ({String description, DayFunction function});

final _stopwatch = Stopwatch();

/// Runs both parts for a day, and prints their output as well as the
/// elapsed time to run each part.
Future<void> runDay({
  required final Year year,
  required final Day day,
  required final DayFunction part1,
  required final DayFunction part2,
  List<AdditionalPart> additional = const [],
  runSample = true,
  runReal = true,
}) async {
  print('Advent of Code - Year ${year.number} - Day ${day.number}');
  for (final resource in [
    if (runSample) Resources.sample,
    if (runReal) Resources.real,
  ]) {
    print('- $resource data:');

    for (final part in [
      (description: '1', function: part1),
      (description: '2', function: part2),
      ...additional,
    ]) {
      final file = resource.file(year, day);
      await runFile(file: file, func: part.function, part: part.description);
    }
  }
}

Future<void> runFile({
  required final File file,
  required final DayFunction func,
  required final String part,
}) async {
  _stopwatch.reset();
  _stopwatch.start();
  final result = await func(file);
  _stopwatch.stop();

  print('  - Part $part: $result  (${_stopwatch.elapsedMilliseconds}ms)');
}
