import 'dart:io';

import 'shared.dart';

const maxSeconds = 100;

/// --- Day 14: Restroom Redoubt ---
///
/// Given a list of robot positions and velocities, determine their
/// position after 100 seconds. Then, split the robots into four
/// quadrants, count the robots in each quadrant (ignoring ones that
/// are on the line between two quadrants), and multiply those values
/// together.
Future<int> calculate(File file) async {
  final data = await loadData(file);

  // Prepare for tracking how many robots are in each quadrant.
  int vertSplit = data.width ~/ 2;
  int horiSplit = data.height ~/ 2;
  Map<Position, int> quadrants = {};

  for (final robot in data.robots) {
    // First, determine where the robot will be at 100 seconds.
    final newPos = robot.posAfter(
      maxSeconds,
      height: data.height,
      width: data.width,
    );

    // Then, assign the robot to a quadrant.
    // The quadrant map keys are points normalized to 1. Points along
    // the (0,0) line are recorded here, but will not be counted later.
    quadrants.update(
      Position(
        directionalDiff(newPos.x, vertSplit),
        directionalDiff(newPos.y, horiSplit),
      ),
      (i) => i + 1,
      ifAbsent: () => 1,
    );
  }

  // Multiply the quadrant counts together. Ignore anything that is
  // along the lines splitting the quadrants.
  final result = quadrants.entries.fold(1, (v, e) {
    if (e.key.x == 0 || e.key.y == 0) {
      return v;
    } else {
      return v * e.value;
    }
  });

  return result;
}

int directionalDiff(int i, int center) {
  int diff = i - center;
  return (diff == 0) ? 0 : diff ~/ diff.abs();
}
