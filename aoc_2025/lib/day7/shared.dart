import 'dart:io';
import 'dart:math';

final class Manifold {
  final Point<int> start;
  final Set<Point<int>> splitters;
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
