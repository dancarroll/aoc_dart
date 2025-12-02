import 'dart:io';
import 'dart:math';

/// Represents a warehouse location type.
enum LocationType { empty, wall, box, robot, boxLeft, boxRight }

/// Represents a specific location in the warehouse.
final class Location {
  LocationType type;

  Location(this.type);

  /// Maps the input character to the appropriate location type.
  factory Location.fromChar(String str) {
    final type = switch (str) {
      '#' => LocationType.wall,
      'O' => LocationType.box,
      '@' => LocationType.robot,
      '.' => LocationType.empty,
      _ => throw Exception('Unsupported character: $str'),
    };
    return Location(type);
  }

  @override
  String toString() => switch (type) {
    LocationType.empty => '.',
    LocationType.wall => '#',
    LocationType.robot => '@',
    LocationType.box => 'O',
    LocationType.boxLeft => '[',
    LocationType.boxRight => ']',
  };
}

/// Represents a single instruction for the robot.
enum Instruction {
  up,
  right,
  down,
  left;

  /// Maps the input character to the appropriate instruction.
  factory Instruction.fromChar(String str) => switch (str) {
    '^' => up,
    '>' => right,
    'v' => down,
    '<' => left,
    _ => throw Exception('Unsupported character: $str'),
  };

  /// Provides a vector representing the instruction direction.
  Point<int> get direction => switch (this) {
    up => Point(0, -1),
    right => Point(1, 0),
    down => Point(0, 1),
    left => Point(-1, 0),
  };
}

/// Represents the warehouse from the problem.
final class Warehouse {
  final Map<Point<int>, Location> map;
  final int height;
  final int width;
  final Point<int> robot;
  final List<Instruction> instructions;

  Warehouse(
    this.map,
    this.robot,
    this.instructions, {
    required this.height,
    required this.width,
  });

  /// Returns the location at the given point. This is a convenience operator
  /// over directly interacting with the map, as it performs the non-null
  /// assertion.
  Location operator [](Point<int> point) => map[point]!;

  /// Find all of the locations of the given type, and sum up their GPS
  /// coordinates (x + 100y).
  int sumOfGpsCoordinates(LocationType type) => map.entries
      .where((e) => e.value.type == type)
      .fold(0, (v, e) => v + e.key.x + 100 * e.key.y);

  @override
  String toString() {
    StringBuffer sb = StringBuffer();

    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        sb.write(this[Point(x, y)].toString());
      }
      sb.writeln();
    }
    return sb.toString();
  }
}

/// Loads a representation of a warehouse layout from a file.
///
/// If [parseAsPart2] is true, the warehouse map is parsed using the changes
/// in part 2 of the problem: the warehouse is twice as wide. For each space
/// encountered in the input, create two location of the same type.
///
/// The robot is not twice as wide, so the robot remains one space on the
/// left side (with a new empty space on its right side).
Future<Warehouse> loadData(File file, {bool parseAsPart2 = false}) async {
  final lines = await file.readAsLines();
  int numPerInput = parseAsPart2 ? 2 : 1;
  final part2Diff = Point(1, 0);

  Map<Point<int>, Location> map = {};
  Point<int>? robot;
  List<Instruction> instructions = [];

  bool parsingMap = true;
  int height = 0, width = 0;
  for (int y = 0; y < lines.length; y++) {
    final line = lines[y].split('');

    if (line.isEmpty) {
      // Switch away from map parsing mode to instruction parsing.
      parsingMap = false;

      // Record the height and width.
      height = y;
      width = lines[y - 1].length;
      continue;
    }

    if (parsingMap) {
      for (int x = 0; x < line.length * numPerInput; x += numPerInput) {
        final point = Point(x, y);
        final inputIndex = x ~/ numPerInput;
        final location = Location.fromChar(line[inputIndex]);

        if (parseAsPart2 && location.type == LocationType.box) {
          map[point] = Location(LocationType.boxLeft);
          map[point + part2Diff] = Location(LocationType.boxRight);
        } else if (parseAsPart2 && location.type == LocationType.robot) {
          map[point] = location;
          map[point + part2Diff] = Location(LocationType.empty);
        } else if (parseAsPart2) {
          map[point] = location;
          map[point + part2Diff] = Location.fromChar(line[inputIndex]);
        } else {
          map[point] = location;
        }

        // Save the initial position of the robot, so we can easily start
        // procesing its moves later.
        if (location.type == LocationType.robot) {
          assert(robot == null, 'Only one robot expected');
          robot = point;
        }
      }
    } else {
      for (final char in line) {
        instructions.add(Instruction.fromChar(char));
      }
    }
  }

  return Warehouse(
    map,
    robot!,
    instructions,
    height: height,
    width: parseAsPart2 ? width * 2 : width,
  );
}
