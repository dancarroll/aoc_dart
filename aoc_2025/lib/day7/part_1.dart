import 'dart:io';
import 'dart:math';

import 'shared.dart';

/// --- Day 7: Laboratories ---
///
/// Tachyon beam traveling through a manifold. An input map contains
/// the beam start position, and the location of splitters. The beam
/// always travels downwards. When hitting a splitter, the beam gets
/// split into twp, placed immediately to the left and right of the
/// splitter, but afterwards will continue to travel straight down.
///
/// Return the number of times a beam gets split.
Future<int> calculate(File file) async {
  final manifold = await loadData(file);

  // Keep track of total splits made.
  int totalSplits = 0;
  // The beam state at each row is stored as a Set, which handles
  // the situation where a beam gets combined (a split places a
  // beam at the same location as another beam).
  Set<Point<int>> beams = {manifold.start};

  // Process one row at a time, for the entire length of the mainfold.
  for (int r = 0; r <= manifold.height; r++) {
    final Set<Point<int>> nextBeams = {};
    for (final beam in beams) {
      // First, determine where the beam would go if no splitter is present.
      final newPoint = beam + Point(1, 0);

      // Check if new position is a splitter. If so, split the beam
      // given the rules laid out in the problem.
      if (manifold.splitters.contains(newPoint)) {
        nextBeams.add(newPoint + Point(0, -1));
        nextBeams.add(newPoint + Point(0, 1));
        totalSplits++;
      } else {
        // Otherwise, the beam just continues down to its new position.
        nextBeams.add(newPoint);
      }
    }

    beams = nextBeams;
  }

  return totalSplits;
}
