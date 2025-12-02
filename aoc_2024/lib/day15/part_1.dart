import 'dart:io';
import 'dart:math';

import 'shared.dart';

/// --- Day 15: Warehouse Woes ---
///
/// Given a warehouse layout with walls, boxes, and a robot, along with a
/// sequence of moves for the robot, process all of the moves to determine
/// the end positions.
///
/// Robot can push an arbitrarily long sequence of boxes, as long as there is
/// a free space at the end of the chain (i.e. not blocked by a wall).
///
/// For each box, sum up the "GPS coordinates" (x + 100y), and return the
/// value.
Future<int> calculate(File file) async {
  final warehouse = await loadData(file);

  Point<int> robot = warehouse.robot;
  for (final instruction in warehouse.instructions) {
    final nextSpace = robot + instruction.direction;

    switch (warehouse[nextSpace].type) {
      case LocationType.box:
        final openSpace = doesPathContainOpenSpace(
          warehouse,
          nextSpace,
          instruction.direction,
        );
        if (openSpace != null) {
          // If there is an open space, rather than moving each of the boxes, we
          // can just fill in the open space with a box.
          warehouse[openSpace].type = LocationType.box;

          // Execute the next case to move the robot.
          continue moveRobot;
        }

      moveRobot:
      case LocationType.empty:
        warehouse[robot].type = LocationType.empty;
        warehouse[nextSpace].type = LocationType.robot;
        robot = nextSpace;

      case LocationType.robot:
        throw Exception('Should never try to move robot onto robot space');

      case LocationType.boxLeft:
      case LocationType.boxRight:
        throw Exception('Two space boxes should not be encountered in part 1');

      case LocationType.wall:
    }
  }

  return warehouse.sumOfGpsCoordinates(LocationType.box);
}

/// Checks to see if there is an empty space along this path. If so, returns
/// the point where the empty space is.
///
/// Returns null if encountering a wall before an empty space.
Point<int>? doesPathContainOpenSpace(
  Warehouse warehouse,
  Point<int> point,
  Point<int> direction,
) {
  Point<int> nextPoint = point + direction;
  while (warehouse[nextPoint].type != LocationType.wall) {
    if (warehouse[nextPoint].type == LocationType.empty) {
      return nextPoint;
    }
    nextPoint = nextPoint + direction;
  }

  return null;
}
