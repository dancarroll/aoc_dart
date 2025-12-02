import 'dart:io';
import 'dart:math';

import 'shared.dart';
import 'paths.dart';

/// Continuing from Part 1, determine the number of unique points that are
/// present along at least one lowest cost path (there may be multiple paths
/// with the same cost).
///
/// Return the number of unique points.
Future<int> calculate(File file) async {
  final maze = await loadData(file);

  final uniquePoints = findBestPaths(
    maze,
  ).fold(<Point<int>>{}, (v, e) => {...v, ...e.visited});
  return uniquePoints.length;
}
