import 'dart:io';
import 'dart:math';

/// Represents the map of the printing department described in the problem.
final class Map {
  final Set<Point<int>> points;
  final int rows;
  final int cols;

  Map(this.points, this.rows, this.cols);

  /// Returns if the point is accessible (fewer than 4 neighbors in the
  /// eigth cardinal positions around the point).
  bool isAccessible(Point<int> point) => numNeighbors(point) < 4;

  /// Return the number of neighbors for the given map and point.
  int numNeighbors(Point<int> point) {
    int r = point.x;
    int c = point.y;
    return [
          (r - 1, c - 1),
          (r - 1, c),
          (r - 1, c + 1),
          (r, c - 1),
          (r, c + 1),
          (r + 1, c - 1),
          (r + 1, c),
          (r + 1, c + 1),
        ]
        .where((pos) {
          final (nr, nc) = pos;
          return nr >= 0 && nr < rows && nc >= 0 && nc < cols;
        })
        .where((pos) => points.contains(Point(pos.$1, pos.$2)))
        .length;
  }
}

Future<Map> loadData(File file) async {
  final lines = await file.readAsLines();

  Set<Point<int>> map = {};
  for (int r = 0; r < lines.length; r++) {
    final row = lines[r].split('');
    for (int c = 0; c < row.length; c++) {
      if (row[c] == '@') {
        map.add(Point(r, c));
      }
    }
  }

  return Map(map, lines.length, lines[0].length);
}
