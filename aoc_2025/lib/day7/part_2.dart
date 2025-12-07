import 'dart:io';
import 'dart:math';

import 'shared.dart';

/// Following from part 1, rather than computing the number of splits, we need
/// to calculate the number of unique paths a beam can take. This is for a
/// single particle, so no need to consider beams combining.
///
/// Return the total number of unique paths.
Future<int> calculate(File file) async {
  final manifold = await loadData(file);

  // Attempting to always store all of the beam permutations will consume more
  // memory than we have available. Since beams will always follow a
  // deterministic path, we can optimize by only calculating the end result from
  // any given position once.
  final savedCalculations = <Point<int>, int>{};

  return _calculate(manifold.start, manifold, savedCalculations);
}

/// Recursive function to calculate the number of unique beam paths will result
/// from the provided [beam] position when traveling through the given
/// [manifold].
int _calculate(
  Point<int> beam,
  Manifold manifold,
  Map<Point<int>, int> savedCalculations,
) {
  // If beam is at the end of the manifold, it can no longer be split, and
  // counts as 1.
  if (beam.x > manifold.height) {
    return 1;
  }

  // Check to see if we have already processed a beam at this position, as the
  // ultimate outcome would be the same.
  final prev = savedCalculations[beam];
  if (prev != null) {
    return prev;
  }

  // Finally, process the beam by recursively calling this function, either
  // with a split or unsplit beam depending on the position.
  late int value;
  if (manifold.splitters.contains(beam)) {
    value =
        _calculate(beam + Point(0, -1), manifold, savedCalculations) +
        _calculate(beam + Point(0, 1), manifold, savedCalculations);
  } else {
    value = _calculate(beam + Point(1, 0), manifold, savedCalculations);
  }

  // Save the calculation before returning the value.
  savedCalculations[beam] = value;
  return value;
}
