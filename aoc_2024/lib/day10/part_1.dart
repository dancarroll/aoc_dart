import 'dart:io';

import 'shared.dart';

/// For each trailhead on the provided topographic map, compute the number of
/// summits that can be reached. Return the sum of this number across all
/// trailheads.
///
/// Topographic maps are of the following form, with elevations between 0 and
/// 9. Trailheads are 0, and summits are 9:
/// 0123
/// 1234
/// 8765
/// 9876
///
/// Valid trails need to increase in elevation by exactly 1 in each step
/// (i.e. they cannot decrease).
Future<int> calculate(File file) async {
  final topoMap = await loadMap(file);

  int sum = 0;
  for (final trailhead in topoMap.trailheads) {
    final summits = _summitsReachableFromPoint(topoMap, trailhead, {});
    sum += summits.length;
  }

  return sum;
}

/// Finds all of the summits reachable from this point. This is a recursive
/// DFS function, and needs to keep track of all the points that have already
/// been visited.
Set<Point> _summitsReachableFromPoint(
  TopographicMap topoMap,
  Point point,
  Set<Point> visitedPoints,
) {
  if (visitedPoints.contains(point)) {
    return {};
  }

  Set<Point> summits = {};
  visitedPoints.add(point);

  for (final nextPoint in topoMap.getValidNextSteps(point)) {
    if (nextPoint.isSummit) {
      summits.add(nextPoint);
    } else {
      summits.addAll(
        _summitsReachableFromPoint(topoMap, nextPoint, visitedPoints),
      );
    }
  }

  return summits;
}
