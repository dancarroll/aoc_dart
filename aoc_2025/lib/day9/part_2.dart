import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:aoc_shared/shared.dart';

import 'shared.dart';

/// Following from part 1, we need to interpret the input points as
/// representing a border path (processed in order based on how they
/// are provided in the input). Then, find the largest rectangle that
/// can be created from any two points, where that rectangle is fully
/// contained within the area closed off by the border path.
Future<int> calculate(File file) async {
  final input = await loadData(file);
  final polygon = Polygon(input);

  return pairs(input)
      .map(
        (pair) => (
          rectangle: Rectangle.fromPoints(pair.$1, pair.$2),
          area: area(pair.$1, pair.$2),
        ),
      )
      .where((record) => polygon.containsRectangle(record.rectangle))
      .map((record) => record.area)
      .max;
}

typedef VerticalEdge = ({int x, int minY, int maxY});
typedef HorizontalEdge = ({int y, int minX, int maxX});

/// Represents a complex polygon area via a list of edges.
final class Polygon {
  final List<VerticalEdge> _verticalEdges = [];
  final List<HorizontalEdge> _horizontalEdges = [];

  Polygon(List<Point<int>> points) {
    for (int i = 0; i < points.length; i++) {
      final point1 = points[i];
      final point2 = points[(i + 1) % points.length];

      // Determine if this is a vertical or horizontal edge, and store in the
      // appropriate list.
      if (point1.x == point2.x) {
        _verticalEdges.add((
          x: point1.x,
          minY: min(point1.y, point2.y),
          maxY: max(point1.y, point2.y),
        ));
      } else {
        _horizontalEdges.add((
          y: point1.y,
          minX: min(point1.x, point2.x),
          maxX: max(point1.x, point2.x),
        ));
      }
    }
  }

  /// Determine if the given rectangle is fully represented within this
  /// polygon.
  bool containsRectangle(Rectangle<int> rect) {
    return !_doesRectIntrudeOnAnEdge(rect) &&
        _isPointInside(Point(rect.left + 0.5, rect.top + 0.5));
  }

  /// Returns true if any part of the rectangle intrudes on an edge of this
  /// polygon.
  bool _doesRectIntrudeOnAnEdge(Rectangle<int> rect) {
    return _verticalEdges.any(
          (edge) =>
              rect.left < edge.x &&
              edge.x < rect.right &&
              edge.minY < rect.bottom &&
              edge.maxY > rect.top,
        ) ||
        _horizontalEdges.any(
          (edge) =>
              rect.top < edge.y &&
              edge.y < rect.bottom &&
              edge.minX < rect.right &&
              edge.maxX > rect.left,
        );
  }

  /// Returns true if the given point lies within this polygon, by performing a
  /// raycasting even-odd test.
  bool _isPointInside(Point<num> point) {
    return _verticalEdges
        .where(
          (edge) =>
              edge.x > point.x && edge.minY < point.y && point.y < edge.maxY,
        )
        .length
        .isOdd;
  }
}
