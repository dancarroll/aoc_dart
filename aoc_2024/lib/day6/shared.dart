import 'dart:io';
import 'dart:math';

/// Represents a location within the map.
class Location {
  /// Coordinates of this location.
  Point<int> point;

  /// List of directions the person was traveling in when they
  /// visited this location. Used for determining cycles.
  final List<Direction> _visitedInDirections = [];

  /// True if this location is an obstruction, and the person is
  /// unable to move to this location.
  bool isObstruction;

  Location(int x, int y, {this.isObstruction = false, Direction? visited})
    : point = Point(x, y) {
    if (visited != null) {
      _visitedInDirections.add(visited);
    }
  }

  /// True if this location was previously visited by the person.
  bool get visited => _visitedInDirections.isNotEmpty;

  /// Mark this location as visited, along the given direction
  /// of travel.
  void visit(Direction direction) {
    if (_visitedInDirections.contains(direction)) {
      throw Exception(
        'Cycle detected! Location $point already visited in $direction',
      );
    }
    _visitedInDirections.add(direction);
  }
}

/// Represents a direction of travel within the map.
enum Direction {
  up,
  right,
  down,
  left;

  /// Calculates the new point based on a given point and this
  /// direction of travel.
  Point<int> move(Point<int> point) => switch (this) {
    up => Point(point.x - 1, point.y),
    down => Point(point.x + 1, point.y),
    left => Point(point.x, point.y - 1),
    right => Point(point.x, point.y + 1),
  };

  /// Returns a new direction based on a 90 degree rotation.
  Direction rotate() {
    var nextIndex = index + 1;
    if (nextIndex >= Direction.values.length) {
      nextIndex = 0;
    }
    return Direction.values[nextIndex];
  }
}

/// Represents a person within the map.
class Person {
  Point<int> point;
  Direction direction;

  Person(int x, int y, this.direction) : point = Point(x, y);

  /// Returns true if the person is in the bounds of a grid with
  /// the given row and column count.
  bool inBounds(int numRows, int numCols) =>
      _inBounds(numRows: numRows, numCols: numCols, x: point.x, y: point.y);

  /// Returns the next step this person will take, given their
  /// current position and direction of travel.
  Point<int> get nextStep => direction.move(point);

  /// Moves the person to the given position.
  void move(Point<int> position) => point = position;
}

bool _inBounds({
  required int numRows,
  required int numCols,
  required int x,
  required int y,
}) => x >= 0 && x < numRows && y >= 0 && y < numCols;

final class LocationMap {
  final List<List<Location>> map;
  final Person person;

  LocationMap(this.map, this.person);

  factory LocationMap.fromStrings(List<String> input) {
    late Person person;
    final List<List<Location>> locationMap = [];

    for (int r = 0; r < input.length; r++) {
      final line = input[r].split('');
      final List<Location> locations = [];

      for (int c = 0; c < line.length; c++) {
        late Location location;
        switch (line[c]) {
          case '.':
            location = Location(r, c);
          case '#':
            location = Location(r, c, isObstruction: true);
          // The sample input, and my real input, both contain
          // `^` as the starting guard position. The puzzle itself
          // does not indicate that the starting direction could
          // be arbitrary, so currently just handling this starting
          // direction.
          case '^':
            location = Location(r, c, visited: Direction.up);
            person = Person(r, c, Direction.up);
          default:
            throw Exception('Unexpected character: ${line[c]}');
        }

        locations.add(location);
      }

      locationMap.add(locations);
    }

    return LocationMap(locationMap, person);
  }

  /// Iterative moves the person one position at a time, until the
  /// person leaves the map.
  ///
  /// If a cycle is detected (person visits the same position and
  /// direction of travel that they did previously), an [Exception]
  /// is thrown.
  void moveUntilPersonLeavesMap() {
    while (person.inBounds(numRows, numCols)) {
      // Determine where the person would move next.
      var nextPosition = person.nextStep;
      var nextLocation = this[nextPosition];

      if (nextLocation != null && nextLocation.isObstruction) {
        // When encountering an obstruction, turn 90 degrees instead
        // of moving.
        person.direction = person.direction.rotate();
      } else {
        // Otherwise, move forward.
        person.move(nextPosition);

        // If this position maps to a map location, mark it as visited.
        nextLocation?.visit(person.direction);
      }
    }
  }

  int get numRows => map.length;
  int get numCols => map[0].length;

  Location? operator [](Point<int> p) {
    if (_inBounds(numRows: numRows, numCols: numCols, x: p.x, y: p.y)) {
      return map[p.x][p.y];
    }
    return null;
  }

  /// Returns a count of all locations that have been visited
  /// so far.
  int get numVisited => visited.length;

  /// Returns a list of all locations that have been visited
  /// so far.
  List<Location> get visited {
    var visited = <Location>[];
    for (final row in map) {
      visited.addAll(row.where((l) => l.visited));
    }
    return visited;
  }
}

Future<LocationMap> loadMap(File file) async {
  final lines = await file.readAsLines();

  return LocationMap.fromStrings(lines);
}
