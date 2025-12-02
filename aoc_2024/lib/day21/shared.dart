import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart' as collection;
import 'package:quiver/collection.dart';

/// Represents a numeric keypad controlled by a robot.
final class NumericKeypad {
  BiMap<Point<int>, String> layout;

  NumericKeypad._(this.layout);

  factory NumericKeypad.standard() {
    return NumericKeypad._(
      BiMap()..addAll({
        Point(0, 0): '7',
        Point(1, 0): '8',
        Point(2, 0): '9',
        Point(0, 1): '4',
        Point(1, 1): '5',
        Point(2, 1): '6',
        Point(0, 2): '1',
        Point(1, 2): '2',
        Point(2, 2): '3',
        Point(0, 3): 'X',
        Point(1, 3): '0',
        Point(2, 3): 'A',
      }),
    );
  }

  Point<int> buttonLocation(String char) => layout.inverse[char]!;

  /// Returns all of the combinations of steps from the starting point to given
  /// keypad character.
  Iterable<DirectionList> stepCombinationsTo(
    Point<int> starting,
    String char,
  ) => generateStepCombinationsTo(
    starting,
    layout.inverse[char]!,
    layout,
    (c) => c != 'X',
  );
}

typedef Direction = ({DirectionalButton direction, Point<int> step});

/// Represents buttons in a directional keypad.
enum DirectionalButton {
  up,
  right,
  down,
  left,
  none,
  activate;

  @override
  String toString() => switch (this) {
    up => '^',
    right => '>',
    down => 'v',
    left => '<',
    activate => 'A',
    _ => throw Exception('unexpected direction'),
  };

  /// List of all directions along with the grid transformation.
  static List<Direction> get directions => [
    (direction: DirectionalButton.up, step: Point(0, -1)),
    (direction: DirectionalButton.right, step: Point(1, 0)),
    (direction: DirectionalButton.down, step: Point(0, 1)),
    (direction: DirectionalButton.left, step: Point(-1, 0)),
  ];
}

/// Represents a directional keypad controller by a robot.
final class DirectionalKeypad {
  BiMap<Point<int>, DirectionalButton> layout;

  DirectionalKeypad._(this.layout);

  factory DirectionalKeypad.standard() {
    return DirectionalKeypad._(
      BiMap()..addAll({
        Point(0, 0): DirectionalButton.none,
        Point(1, 0): DirectionalButton.up,
        Point(2, 0): DirectionalButton.activate,
        Point(0, 1): DirectionalButton.left,
        Point(1, 1): DirectionalButton.down,
        Point(2, 1): DirectionalButton.right,
      }),
    );
  }

  /// Returns the grid location of the given [button].
  Point<int> buttonLocation(DirectionalButton button) =>
      layout.inverse[button]!;

  /// Returns all of the combinations of steps from the starting point to
  /// the given [target] button.
  Set<DirectionList> stepCombinationsTo(
    Point<int> starting,
    DirectionalButton target,
  ) => generateStepCombinationsTo(
    starting,
    layout.inverse[target]!,
    layout,
    (button) => button != DirectionalButton.none,
  );
}

/// Represents a list of direction button presses.
///
/// This wraps a normal list, but adds support for equality checking in order
/// to have lists of directions used as keys in sets/maps.
final class DirectionList extends collection.DelegatingList<DirectionalButton> {
  DirectionList(super.base);

  List<DirectionalButton> get _listBase => super.toList();

  /// Split the direction list in groups of button presses, each ending with
  /// an activate button press.
  Iterable<DirectionList> splitIntoActivateGroups() => _listBase
      .splitAfter((b) => b == DirectionalButton.activate)
      .map(DirectionList.new);

  @override
  bool operator ==(Object other) {
    if (other is DirectionList) {
      return toString() == other.toString();
    }
    return false;
  }

  @override
  int get hashCode => Object.hashAll(this);

  @override
  String toString() => directionsToString(_listBase);
}

/// Returns all of the combinations of steps from the given starting point to
/// given [target].
///
/// This is a generic function used for both the numeric and directional
/// keypads, so also need to provide a map to resolve what button is at each
/// point, and a function to define which locations are not valid (e.g.
/// blank spots the robot can never cross over).
Set<DirectionList> generateStepCombinationsTo<T>(
  Point<int> starting,
  Point<int> target,
  BiMap<Point<int>, T> map,
  bool Function(T) isValid,
) {
  // Store a list of paths. Each path needs to keep track of its current
  // location, and list of directions so far.
  List<(Point<int>, DirectionList)> paths = [];
  paths.add((starting, DirectionList([])));

  while (paths.none((p) => p.$1 == target)) {
    List<(Point<int>, DirectionList)> newPaths = [];
    // Increment each path by one space.
    for (final path in paths) {
      for (final step in DirectionalButton.directions) {
        final newLocation = path.$1 + step.step;
        final buttonAtLocation = map[newLocation];

        // Only allow moves that remain within the keypad, are not over
        // empty spaces ('X'), and move the pointer closer to the target.
        if (buttonAtLocation != null &&
            isValid(buttonAtLocation) &&
            path.$1.squaredDistanceTo(target) >
                newLocation.squaredDistanceTo(target)) {
          newPaths.add((
            path.$1 + step.step,
            DirectionList([...path.$2, step.direction]),
          ));
        }
      }
    }

    paths = newPaths;
  }

  return paths
      // Filter out any path that didn't actually reach the target (this would
      // be any path that is not a shortest-length path).
      .where((p) => p.$1 == target)
      .map((p) => p.$2)
      // All buttons need to be activated after moving to them, so add the
      // activate button to the end of each path.
      .map((p) => p..add(DirectionalButton.activate))
      .toSet();
}

/// Generates a string representation of a list of direction buttons.
String directionsToString(List<DirectionalButton> directions) {
  StringBuffer sb = StringBuffer();
  for (final direction in directions) {
    sb.write(direction.toString());
  }
  return sb.toString();
}

/// Loads the data for a maze from a file.
Future<List<String>> loadData(File file) async {
  final lines = await file.readAsLines();
  return lines;
}
