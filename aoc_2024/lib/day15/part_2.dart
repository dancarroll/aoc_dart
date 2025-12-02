import 'dart:io';
import 'dart:math';

import 'shared.dart';

/// Continuing from part 1, but the map is twice as long. All
/// boxes now take up two spaces, which leads to more complexity
/// when determining whether the robot can push a chain of boxes
/// (as they may only partially overlap).
///
/// Return value is the same as before. Distances should be
/// calculated from the left side of the boxes.
Future<int> calculate(File file) async {
  final warehouse = await loadData(file, parseAsPart2: true);

  Point<int> robot = warehouse.robot;
  for (final instruction in warehouse.instructions) {
    final nextSpace = robot + instruction.direction;

    switch (warehouse[nextSpace].type) {
      case LocationType.boxLeft:
      case LocationType.boxRight:
        // Determine moveable boxes is a lot more complicated this time.
        final moveablePoints = findBoxesThatAreMoveable(
          warehouse,
          nextSpace,
          instruction.direction,
        );

        if (moveablePoints.isNotEmpty) {
          // Move all of the points in the given direction.
          movePoints(warehouse, moveablePoints, instruction.direction);

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

      case LocationType.box:
        throw Exception(
          'Single space boxe should not be encountered in part 2',
        );

      case LocationType.wall:
    }
  }

  return warehouse.sumOfGpsCoordinates(LocationType.boxLeft);
}

/// Given a starting point and a direction, find all of the points that can be
/// moved. If there are any walls that will block the cascading group of boxes
/// from moving, this will return empty.
List<Point<int>> findBoxesThatAreMoveable(
  Warehouse warehouse,
  Point<int> point,
  Point<int> direction,
) {
  final type = warehouse[point].type;
  assert(
    type == LocationType.boxLeft || type == LocationType.boxRight,
    'Only expect box types',
  );

  List<Point<int>> moveablePoints = [];
  final moveable = recursivelyFindMoveableBoxes(
    warehouse,
    point,
    direction,
    moveablePoints,
  );

  return moveable ? moveablePoints : [];
}

/// Recursively process the given point and direction to determine all of the
/// boxes that can be moved.
///
/// If the list of boxes can be moved, returns true. If they cannot be moved,
/// returns false and the list of boxes should be ignored.
bool recursivelyFindMoveableBoxes(
  Warehouse warehouse,
  Point<int> point,
  Point<int> direction,
  List<Point<int>> moveablePoints,
) {
  final type = warehouse[point].type;

  // If this is a wall, immediately return false as this would indicate
  // an illegal move.
  if (type == LocationType.wall) {
    return false;
  }

  // If this space is empty, there is nothing left to process on this
  // chain, so just return true.
  if (type == LocationType.empty) {
    return true;
  }

  // If we've already processed this point, immediately return true.
  if (moveablePoints.contains(point)) {
    return true;
  }

  Set<Point<int>> curr = {};
  if (type == LocationType.boxLeft || type == LocationType.boxRight) {
    final boxPartner =
        point + ((type == LocationType.boxLeft) ? Point(1, 0) : Point(-1, 0));

    // Track both box parts for later moving (if we eventually find the
    // appropriate empty spaces).
    moveablePoints.add(point);
    moveablePoints.add(boxPartner);

    // If we are pushing in the direction of the box partner, just add the
    // partner to the list that we will recursively explore. Otherwise, add
    // both parts, as they may end up revealing different barriers.
    if (direction.x != 0) {
      curr.add(point + direction);
    } else {
      curr.add(point);
      curr.add(boxPartner);
    }
  }

  bool moveable = true;
  for (final boxPart in curr) {
    moveable &= recursivelyFindMoveableBoxes(
      warehouse,
      boxPart + direction,
      direction,
      moveablePoints,
    );

    // If we've already encountered something blocking the move,
    // short-circuit instead of processing the other branch.
    if (!moveable) break;
  }

  return moveable;
}

/// Given the list of points and the direction, moves each of the points one
/// step.
///
/// This function will sort the points first, to ensure it doesn't accidentally
/// overwrite any important data before moving.
void movePoints(
  Warehouse warehouse,
  List<Point<int>> points,
  Point<int> direction,
) {
  // Sort all the objects in reverse order from the direction we are traveling.
  // Since one of the cardinal directions will always be zero, can use a simple
  // comparison function that just multiplies each component and adds them
  // together.
  points.sort(
    (b, a) => (a.x * direction.x + a.y * direction.y).compareTo(
      b.x * direction.x + b.y * direction.y,
    ),
  );

  // After sorting, iterate through each point and move it.
  for (final point in points) {
    assert(
      warehouse[point + direction].type == LocationType.empty,
      'Expect this space to be empty',
    );
    warehouse[point + direction].type = warehouse[point].type;
    warehouse[point].type = LocationType.empty;
  }
}
