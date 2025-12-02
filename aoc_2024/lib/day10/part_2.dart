import 'dart:io';

import 'shared.dart';

/// Continuing from part 1, rather than computing the number of summits per
/// trailhead, we need to determine the trailhead ratings: the number of unique
/// trails per trailhead (there may be multiple paths to reach a given summit
/// from the same trailhead).
///
/// Return the sum of all of the trailhead ratings.
Future<int> calculate(File file) async {
  final topoMap = await loadMap(file);

  int sum = 0;
  for (final trailhead in topoMap.trailheads) {
    final summits = _summitsReachableFromPoint(topoMap, trailhead);
    sum += summits.length;
  }

  return sum;
}

/// Finds all of the summits reachable from this point. Because we are not
/// tracking visited points in this DFS algorithm, this will return the same
/// point multiple times if it is reachable via multiple paths. Since there is a
/// requirement of the next elevation increasing by exactly one, there is no
/// risk of backtracking and hitting endless cycles.
List<Point> _summitsReachableFromPoint(TopographicMap topoMap, Point point) {
  List<Point> summits = [];

  for (final nextPoint in topoMap.getValidNextSteps(point)) {
    if (nextPoint.isSummit) {
      summits.add(nextPoint);
    } else {
      summits.addAll(_summitsReachableFromPoint(topoMap, nextPoint));
    }
  }

  return summits;
}
