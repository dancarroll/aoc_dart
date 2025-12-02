import 'dart:io';
import 'dart:math';

/// Represents a location within the maze.
enum Location { wall, empty, start, end }

/// Represents a maze in the Reindeer Olympics.
final class Maze {
  /// Maze representation, which is just a map of points to their types.
  final Map<Point<int>, Location> map;

  /// Reference to the starting point.
  final Point<int> start;

  /// Reference to the ending point.
  final Point<int> end;

  Maze(this.map, this.start, this.end);
}

/// Loads the data for a maze from a file.
Future<Maze> loadData(File file) async {
  final lines = await file.readAsLines();

  Map<Point<int>, Location> maze = {};
  Point<int>? start;
  Point<int>? end;
  for (int y = 0; y < lines.length; y++) {
    final line = lines[y].split('');
    for (int x = 0; x < line.length; x++) {
      final location = switch (line[x]) {
        'S' => Location.start,
        'E' => Location.end,
        '#' => Location.wall,
        '.' => Location.empty,
        _ => throw Exception('Unexpected character ${line[x]}'),
      };
      maze[Point(x, y)] = location;

      // If we processed a start/end, save it off.
      if (location == Location.start) {
        assert(start == null, 'More than one start found');
        start = Point(x, y);
      } else if (location == Location.end) {
        assert(end == null, 'More than one end found');
        end = Point(x, y);
      }
    }
  }

  assert(start != null, 'Did not find start');
  assert(end != null, 'Did not find end');
  return Maze(maze, start!, end!);
}
