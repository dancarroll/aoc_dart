import 'dart:io';
import 'dart:math';

import 'package:aoc_shared/shared.dart';

import 'shared.dart';

/// Continuing from Part 1, determine the first byte that will cut off access
/// to the exit. Return the coordinates of that byte.
Future<String> calculate(File file) async {
  final memorySpace = await loadData(file);

  // Perform a binary search to find the lowest number of seconds where it is
  // no longer possible to escape through the map.
  int lowerBound = memorySpace.startingSimulationNanoseconds;
  int upperBound = memorySpace.incomingBytes.length;
  int curr = lowerBound + ((upperBound - lowerBound) ~/ 2);

  int lowestEmpty = maxInt;

  while (lowerBound < upperBound) {
    final steps = findFewestSteps(memorySpace, memorySpace.simulate(curr));

    // Determine whether to search higher or lower.
    if (steps >= 0) {
      lowerBound = curr;
    } else {
      lowestEmpty = min(lowestEmpty, curr);
      upperBound = curr;
    }

    // Break when we have centered on a single value.
    final oldCurr = curr;
    curr = lowerBound + ((upperBound - lowerBound) ~/ 2);
    if (oldCurr == curr) {
      break;
    }
  }

  // Return the coordinates that were corrupted at that time.
  final point = memorySpace.incomingBytes[lowestEmpty - 1];
  return '${point.x},${point.y}';
}
