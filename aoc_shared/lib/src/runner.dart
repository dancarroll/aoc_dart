import 'dart:io';

import 'resources.dart';

typedef DayFunction = Future<dynamic> Function(File);

typedef AdditionalPart = ({
  Part part,
  DayFunction function,
  String extraDescription,
});

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
  String Function(Part, ResourceType)? fileSuffix,
}) async {
  print('Advent of Code - Year ${year.number} - Day ${day.number}');
  for (final resource in [
    if (runSample) Resources.sample,
    if (runReal) Resources.real,
  ]) {
    print('- $resource data:');

    for (final part in [
      (part: Part.part1, function: part1, extraDescription: ''),
      (part: Part.part2, function: part2, extraDescription: ''),
      ...additional,
    ]) {
      final suffix = fileSuffix == null
          ? ''
          : fileSuffix(part.part, resource.type);
      final file = resource.file(year, day, filenameSuffix: suffix);
      final description =
          '${part.part.number}'
          '${part.extraDescription.isEmpty ? '' : ' (${part.extraDescription})'}';
      await runFile(
        file: file,
        func: part.function,
        partDescription: description,
      );
    }
  }
}

Future<void> runFile({
  required final File file,
  required final DayFunction func,
  required final String partDescription,
}) async {
  _stopwatch.reset();
  _stopwatch.start();
  final result = await func(file);
  _stopwatch.stop();

  print(
    '  - Part $partDescription: $result  (${_stopwatch.elapsedMilliseconds}ms)',
  );
}
