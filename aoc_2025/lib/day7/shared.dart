import 'dart:io';
import 'dart:math';

/// Represents the manifold in which the tachyon beams travel.
final class Manifold {
  /// Starting position of the first beam.
  final Point<int> start;

  /// Location of beam splitters in the manifold.
  final Set<Point<int>> splitters;

  /// Total height of the manifold.
  final int height;

  Manifold(this.start, this.splitters, this.height);
}

Future<Manifold> loadData(File file) async {
  final lines = await file.readAsLines();

  Point<int>? start;
  Set<Point<int>> splitters = {};

  int r = 0;
  for (; r < lines.length; r++) {
    final line = lines[r];
    for (int c = 0; c < line.length; c++) {
      if (line[c] == 'S') {
        start = Point(r, c);
      } else if (line[c] == '^') {
        splitters.add(Point(r, c));
      }
    }
  }

  assert(start != null, 'Did not find starting point');
  return Manifold(start!, splitters, r);
}
