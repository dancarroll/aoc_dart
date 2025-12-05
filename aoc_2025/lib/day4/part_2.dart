import 'dart:io';

import 'shared.dart';

/// Continuing from Part 1, we need to figure out the maximum
/// number of paper rolls that are accessible by iteratively
/// removing all accessible rolls. Continue until no more rolls
/// are accessible, and return the total number of rolls that
/// were removed.
Future<int> calculate(File file) async {
  final map = await loadData(file);

  int totalRemoved = 0;
  int numRemoved = 0;
  do {
    totalRemoved += numRemoved;
    numRemoved = 0;

    final points = map.points.toList();
    for (final point in points) {
      if (map.isAccessible(point)) {
        map.points.remove(point);
        numRemoved++;
      }
    }
  } while (numRemoved > 0);

  return totalRemoved;
}
