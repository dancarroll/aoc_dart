import 'dart:io';
import 'dart:math';

/// Calculates the rectangular area given the two corner points.
int area(Point<int> a, Point<int> b) =>
    ((b.x - a.x).abs() + 1) * ((b.y - a.y).abs() + 1);

Future<List<Point<int>>> loadData(File file) async {
  final lines = await file.readAsLines();

  final points = lines
      .map((line) => line.split(',').map(int.parse).toList())
      .map((parts) => Point(parts[0], parts[1]))
      .toList();

  return points;
}
