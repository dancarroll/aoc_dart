import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';

/// Represents a path in a map.
final class Path implements Comparable<Path> {
  /// The current (latest) point in the path.
  final Point<int> point;

  /// Number of steps taken so far in the path.
  final int steps;

  Path(this.point, this.steps);

  /// Comparison for paths is based on the number of steps so far, plus
  /// the shortest potential number of steps remaining (Manhattan distance).
  @override
  int compareTo(Path other) =>
      (steps + minStepsRemaining(point)) -
      (other.steps + minStepsRemaining(other.point));

  /// The minimum potential steps remaining (Manhattan distance).
  static int minStepsRemaining(Point<int> p) => (71 - p.x) + (71 - p.y);
}

/// Returns the fewest steps to traverse from the start to the exit of the given
/// memory space.
int findFewestSteps(MemorySpace memorySpace, Set<Point<int>> blockedPoints) {
  final paths = PriorityQueue<Path>();
  paths.add(Path(Point(0, 0), 0));

  Set<Point<int>> visited = {};

  while (paths.isNotEmpty) {
    final path = paths.removeFirst();
    visited.add(path.point);
    if (memorySpace.isExit(path.point)) {
      return path.steps;
    }

    // Determine all valid moves from the current point. Append the first to
    // the current path, and add the additional moves to new candidate lists.
    final moves = Direction.allMoves(path.point)
        .where((p) => memorySpace.inBounds(p))
        .where((p) => !blockedPoints.contains(p))
        .where((p) => !visited.contains(p));
    paths.addAll(moves.map((p) => Path(p, path.steps + 1)));
  }

  return -1;
}

/// Represents a direction of travel in a map.
enum Direction {
  up,
  right,
  down,
  left;

  /// Returns coordinates after moving this direction from the given [point].
  Point<int> move(Point<int> point) => switch (this) {
    up => Point(point.x, point.y - 1),
    down => Point(point.x, point.y + 1),
    left => Point(point.x - 1, point.y),
    right => Point(point.x + 1, point.y),
  };

  /// Returns all of the moves from a given [point].
  static List<Point<int>> allMoves(Point<int> point) {
    return Direction.values.map((d) => d.move(point)).toList();
  }
}

/// Represents the memory space.
final class MemorySpace {
  final List<Point<int>> incomingBytes;
  final int height;
  final int width;

  MemorySpace(this.incomingBytes, this.height, this.width);

  // Another day where parameters differ between the sample and real inputs, so
  // another unfortunate hack.
  // Sample input should simulate the first 12 bytes, while the real input
  // should simulate the first 1024 bytes.
  int get startingSimulationNanoseconds => (width == 7) ? 12 : 1024;

  Point<int> get start => Point(0, 0);

  Point<int> get exit => Point(width - 1, height - 1);

  /// Returns true if the given point is in the bounds of the memory space.
  bool inBounds(Point<int> point) =>
      point.x >= 0 && point.x < width && point.y >= 0 && point.y < height;

  /// Returns true if the given point is the map exit.
  bool isExit(Point<int> point) => point == exit;

  /// Simulates the state of the memory after [nanoseconds].
  Set<Point<int>> simulate(int nanoseconds) =>
      incomingBytes.sublist(0, nanoseconds).toSet();
}

/// Loads a list of memory locations, with each line representing the
/// location that will be corrupted each nanosecond.
Future<MemorySpace> loadData(File file) async {
  final lines = await file.readAsLines();

  List<Point<int>> incomingBytes = [];
  int maxX = 0, maxY = 0;
  for (final line in lines) {
    final coordinates = line.split(',').map(int.parse).toList();
    assert(coordinates.length == 2, 'Expect x,y coordinates');

    incomingBytes.add(Point(coordinates[0], coordinates[1]));
    maxX = max(maxX, coordinates[0]);
    maxY = max(maxY, coordinates[1]);
  }

  return MemorySpace(incomingBytes, maxY + 1, maxX + 1);
}
