import 'dart:io';

import 'package:path/path.dart' as path;

/// Represents the different resource types available.
enum ResourceType {
  /// The sample test input, which is the same for all
  /// participants.
  sample,

  /// The real test input, which is unique per participant
  /// (and is not checked into the repository, following
  /// AoC guidelines).
  real,

  /// Extra inputs, not part of the official AoC inputs.
  /// For example, stress-test inputs shared on Reddit.
  fun,
}

/// Represents each year in Advent of Code.
enum Year {
  y2024,
  y2025;

  String get number => name.substring(1);

  String get rootDir => 'aoc_$number';
}

/// Represents each day in Advent of Code.
enum Day {
  day1,
  day2,
  day3,
  day4,
  day5,
  day6,
  day7,
  day8,
  day9,
  day10,
  day11,
  day12,
  day13,
  day14,
  day15,
  day16,
  day17,
  day18,
  day19,
  day20,
  day21,
  day22,
  day23,
  day24,
  day25;

  String get number => name.substring(3);
}

/// Manager for loading a resource file, based on type and day.
final class Resources {
  final ResourceType type;

  Resources(this.type);

  static Resources get sample => Resources(ResourceType.sample);

  static Resources get real => Resources(ResourceType.real);

  static Resources get fun => Resources(ResourceType.fun);

  /// Create a file reference for the given year and day.
  File file(Year year, Day day) => fileByName(year, day.name);

  /// Create a file reference for the given day.
  File fileByName(final Year year, final String name) =>
      _internalFile(rootDir: year.rootDir, name: name);

  File _internalFile({required String rootDir, required String name}) {
    final folder = switch (type) {
      ResourceType.sample => 'sample_data',
      ResourceType.real => 'real_data',
      ResourceType.fun => 'fun_data',
    };

    // Check to see if the current directory already ends with the root
    // directory name. This is intended to support running code like tests
    // from either the root package directory, or within the subpackage
    // directory.
    final pathPrefix = path.current.endsWith(rootDir) ? '' : rootDir;
    return File(path.join(pathPrefix, 'resources', folder, '$name.txt'));
  }

  @override
  String toString() => type.name;
}
