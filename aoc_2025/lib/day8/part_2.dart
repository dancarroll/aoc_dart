import 'dart:io';

import 'package:aoc_shared/shared.dart';

import 'shared.dart';

/// Following from part 1, we need to continue making connections until
/// a single circuit has been created. Take the last connection needed for
/// the single circuit, and multiply the X coordinates of each junction
/// box.
Future<int> calculate(File file) async {
  final playground = await loadData(file);

  // Run the logic to combine into a single circuit.
  final circuitResult = playground.createCircuitsUntilComplete(
    maxConnections: maxInt,
  );

  // Return the product of the x coordinates of the last connection.
  return circuitResult.lastConnection.$1.x.toInt() *
      circuitResult.lastConnection.$2.x.toInt();
}
