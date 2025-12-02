import 'dart:io';
import 'dart:math';

typedef Position = Point<int>;
typedef Velocity = Point<int>;

/// Represents the input data needed to solve the problem.
final class Data {
  final int height;
  final int width;
  final List<Robot> robots;

  Data(this.robots, {required this.height, required this.width});
}

/// Represent a single robot's position and velocity.
final class Robot {
  /// Robot's current position.
  final Position pos;

  // Robot's velocity. This can never change.
  final Velocity velo;

  Robot(this.pos, this.velo);

  /// Returns the position of the robot after [seconds] after elapsed, when
  /// moving in a grid sized ([width], [height]).
  Position posAfter(int seconds, {required int height, required int width}) =>
      Position(
        (pos.x + (velo.x * seconds)) % width,
        (pos.y + (velo.y * seconds)) % height,
      );

  @override
  String toString() => 'Position: $pos, Velocity: $velo';
}

/// Loads a list of robot positions and velocities from a file.
Future<Data> loadData(File file) async {
  final lines = await file.readAsLines();

  List<Robot> robots = [];
  final lineRegex = RegExp(
    r'^p=(?<px>\d+),(?<py>\d+) v=(?<vx>-?\d+),(?<vy>-?\d+)$',
  );
  for (final line in lines) {
    final match = lineRegex.firstMatch(line)!;
    match.namedGroup('px');
    robots.add(
      Robot(
        Point(toInt(match.namedGroup('px')), toInt(match.namedGroup('py'))),
        Point(toInt(match.namedGroup('vx')), toInt(match.namedGroup('vy'))),
      ),
    );
  }

  // For some reason, height and width are not in the problem's input.
  // This varies between the sample and real input, so I hacked in this
  // quick approach to vary the size of the map.
  final height = file.path.contains('real_data') ? 103 : 7;
  final width = file.path.contains('real_data') ? 101 : 11;

  return Data(robots, height: height, width: width);
}

/// Parses a nullable string as an integer, throwing an error if the string
/// is actually null.
int toInt(String? str) {
  if (str == null) throw ArgumentError.notNull('str');
  return int.parse(str);
}
