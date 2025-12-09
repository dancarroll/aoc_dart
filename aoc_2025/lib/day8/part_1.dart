import 'dart:io';

import 'package:collection/collection.dart';

import 'shared.dart';

/// --- Day 8: Playground ---
///
/// The input are 3d coordinates to junction boxes that need to be
/// connected. Find the closest (by Euclidean distance) junction
/// boxes (10 for the sample input, 1000 for real input) and connect
/// them. Determine the 3 largest circuits created, and return the
/// result of multiplying the number of junction boxes in each.
Future<int> calculate(File file) async {
  final playground = await loadData(file);

  // One of the rare problems where execution logic needs to differ between
  // sample and real inputs.
  final connectionsToMake = file.path.contains('real_data') ? 1000 : 10;

  // Run the logic to combine junctions into circuits, up to the max
  // number of connections.
  final circuits = playground.createCircuitsUntilComplete(
    maxConnections: connectionsToMake,
  );

  // Finally, take the top three biggest circuits, and return the result of
  // multiplying the circuit sizes together.
  final value = circuits
      .sortedBy((circuit) => circuit.length)
      .reversed
      .take(3)
      .fold(1, (val, circuit) => val * circuit.length);
  return value;
}
