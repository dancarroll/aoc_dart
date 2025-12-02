import 'dart:io';

import 'shared.dart';

/// As a followup to part 1, determine where a new obstruction could
/// be placed in the map in order to get the person stuck in a loop.
/// Calculate how many possible options there are for adding a single
/// obstruction.
Future<int> calculate(File file) async {
  final mapWithOriginalPath = await loadMap(file);

  // Execute the logic in order to get a list of all locations visited
  // by the person in the original map. This will give a list of
  // candidate locations to add a new obstruction.
  mapWithOriginalPath.moveUntilPersonLeavesMap();

  // We could attempt to put an obstruction in every empty space on the
  // map. However, it is an optimization to only check the spaces that
  // the person would visit on its original path.
  final candidateLocations = mapWithOriginalPath.visited.map((l) => l.point);

  var candidatesWithCycle = 0;
  for (final candidate in candidateLocations) {
    // Reload the original map, in order to get a fresh instance.
    final candidateMap = await loadMap(file);

    // Add an obstruction in the candidate location.
    candidateMap.map[candidate.x][candidate.y].isObstruction = true;

    // Attempt to move the person. This will throw if a cycle is detected
    // (a cycle can be determined if the person enters a previously
    // visited location along the same direction of travel).
    try {
      candidateMap.moveUntilPersonLeavesMap();
    } catch (e) {
      candidatesWithCycle++;
    }
  }

  return candidatesWithCycle;
}
