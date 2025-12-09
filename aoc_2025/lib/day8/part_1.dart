import 'dart:io';

import 'package:collection/collection.dart';

import 'shared.dart';
import 'package:aoc_shared/shared.dart';

/// --- Day 8: Playground ---
///
/// The input are 3d coordinates to junction boxes that need to be
/// connected. Find the closest (by Euclidean distance) junction
/// boxes (10 for the sample input, 1000 for real input) and connect
/// them. Determine the 3 largest circuits created, and return the
/// result of multiplying the number of junction boxes in each.
Future<int> calculate(File file) async {
  final junctions = await loadData(file);

  // One of the rare problems where execution logic needs to differ between
  // sample and real inputs.
  final connectionsToMake = file.path.contains('real_data') ? 1000 : 10;

  // Create all of the pairs, and sort by shortest distance.
  final pointPairs = pairs(junctions);
  pointPairs.sort((a, b) {
    final distPairA = a.$1.distanceToSquared(a.$2);
    final distPairB = b.$1.distanceToSquared(b.$2);
    return distPairA.compareTo(distPairB);
  });

  // Take each junction box, and put it in its own circuit to start.
  final circuits = junctions.map((point) => {point}).toList();

  // Iterate through the number of connections we need to make, picking the
  // shortest distances first.
  for (int i = 0; i < connectionsToMake; i++) {
    final pair = pointPairs[i];

    // Find the circuits that contain each of the points being processed.
    final circuitsWithPair = circuits
        .where(
          (circuit) => circuit.contains(pair.$1) || circuit.contains(pair.$2),
        )
        .toList();

    switch (circuitsWithPair.length) {
      case 1:
        // Nothing to do, they are already in the same circuit.
        break;
      case 2:
        // Combine the two circuits.
        circuitsWithPair[0].addAll(circuitsWithPair[1]);
        circuits.remove(circuitsWithPair[1]);
        break;
      default:
        // If we were mutating the sets properly, we should never get zero or
        // 2+ circuits, so throw an error.
        throw StateError(
          'Unexpected number of circuits containing pair: $circuitsWithPair',
        );
    }
  }

  // Finally, take the top three biggest circuits, and return the result of
  // multiplying the circuit sizes together.
  final value = circuits
      .sortedBy((circuit) => circuit.length)
      .reversed
      .take(3)
      .fold(1, (val, circuit) => val * circuit.length);
  return value;
}
