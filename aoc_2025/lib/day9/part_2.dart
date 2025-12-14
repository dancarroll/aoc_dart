import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:aoc_shared/shared.dart';

import 'shared.dart';

/// Following from part 1, we need to interpret the input points as
/// representing a border path (processed in order based on how they
/// are provided in the input). Then, find the largest rectangle that
/// can be created from any two points, where that rectangle in fully
/// contained within the area closed off by the border path.
///
/// NOTE: This is my original solution, which is very slow. Still
/// working on a better implementation, but submitting what I have for
/// now (takes almost 4 minutes to run).
Future<int> calculate(File file) async {
  final input = await loadFloor(file);

  final rectangles = pairs(input.redTiles.toList())
      .map((pair) => (pair.$1, pair.$2, area(pair.$1, pair.$2)))
      .sortedBy((record) => record.$3)
      .reversed
      .toList();

  for (int i = 0; i < rectangles.length; i++) {
    final record = rectangles[i];
    if (doesBoundingBoxContainOnlyTiles(
      record.$1,
      record.$2,
      input.borderTiles,
      input.capturedRegion,
    )) {
      return record.$3;
    }
  }

  return 0;
}

bool doesBoundingBoxContainOnlyTiles(
  Point<int> a,
  Point<int> b,
  Set<Point<int>> borderTiles,
  CapturedRegion capturedRegion,
) {
  for (final point in generateBorderPoints(a, b)) {
    if (!capturedRegion.contains(point) && !borderTiles.contains(point)) {
      return false;
    }
  }
  return true;
}

/// A generator that yields every point along the border of the rectangle
/// formed by [p1] and [p2].
Iterable<Point<int>> generateBorderPoints(Point<int> p1, Point<int> p2) sync* {
  final minX = min(p1.x, p2.x);
  final maxX = max(p1.x, p2.x);
  final minY = min(p1.y, p2.y);
  final maxY = max(p1.y, p2.y);

  // Top Edge (Left to Right)
  for (int x = minX; x <= maxX; x++) {
    yield Point(x, minY);
  }

  // If the rectangle has no height (is a horizontal line), we are done.
  if (minY == maxY) return;

  // Right Edge (Top+1 to Bottom)
  // Start at minY + 1 to avoid duplicating the Top-Right corner.
  for (int y = minY + 1; y <= maxY; y++) {
    yield Point(maxX, y);
  }

  // If the rectangle has no width (is a vertical line), we are done.
  if (minX == maxX) return;

  // Bottom Edge (Right-1 to Left)
  // Start at maxX - 1 to avoid duplicating Bottom-Right.
  // End at minX to include Bottom-Left.
  for (int x = maxX - 1; x >= minX; x--) {
    yield Point(x, maxY);
  }

  // Left Edge (Bottom-1 to Top+1)
  // Start at maxY - 1 to avoid duplicating Bottom-Left.
  // End at minY + 1 to avoid duplicating Top-Left.
  for (int y = maxY - 1; y > minY; y--) {
    yield Point(minX, y);
  }
}
