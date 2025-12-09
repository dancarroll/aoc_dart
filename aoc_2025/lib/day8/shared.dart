import 'dart:io';

import 'package:aoc_shared/shared.dart';
import 'package:vector_math/vector_math.dart';

/// Represents the playground in the problem, with junction boxes laid
/// out in 3D space.
final class Playground {
  final List<Vector3> junctions;

  Playground(this.junctions);

  /// Create all of the junction pairs, sorted by shortest distance.
  List<(Vector3, Vector3)> pairsByShortestDistance() {
    final pointPairs = pairs(junctions);
    pointPairs.sort((a, b) {
      final distPairA = a.$1.distanceToSquared(a.$2);
      final distPairB = b.$1.distanceToSquared(b.$2);
      return distPairA.compareTo(distPairB);
    });
    return pointPairs;
  }

  /// Iterate through the junction pairs, up until [maxConnections],
  /// connecting them until there is a single circuit.
  List<Set<Vector3>> createCircuitsUntilComplete({
    required int maxConnections,
  }) {
    // Create all of the pairs, and sort by shortest distance.
    final pointPairs = pairsByShortestDistance();

    // Take each junction box, and put it in its own circuit to start.
    final circuits = junctions.map((point) => {point}).toList();

    // Iterate through the number of connections we need to make, picking the
    // shortest distances first.
    for (int i = 0; i < maxConnections; i++) {
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
    return circuits;
  }
}

Future<Playground> loadData(File file) async {
  final lines = await file.readAsLines();

  final junctions = lines
      .map((line) => line.split(',').map(int.parse).toList())
      .map(
        (parts) => Vector3(
          parts[0].toDouble(),
          parts[1].toDouble(),
          parts[2].toDouble(),
        ),
      )
      .toList();
  return Playground(junctions);
}
