import 'dart:io';

import 'shared.dart';

/// --- Day 18: RAM Run ---
///
/// Given a list of bytes per nanosecond, where the location each nanosecond
/// will become corrupted, determine the shortest number of steps to escape
/// the map after a given number of nanoseconds.
Future<int> calculate(File file) async {
  final memorySpace = await loadData(file);

  final blocked = memorySpace.simulate(
    memorySpace.startingSimulationNanoseconds,
  );
  return findFewestSteps(memorySpace, blocked);
}
