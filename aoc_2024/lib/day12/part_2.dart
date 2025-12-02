import 'dart:io';

import 'shared.dart';

typedef AreaAndSides = ({int area, int sides});

/// Following from part 1, fence costs are area * number of sides of the
/// region. Sides are counted once for any straightline path.
Future<int> calculate(File file) async {
  final visited = <(int, int)>{};
  final map = await loadData(file);

  int fenceCost = 0;
  for (int r = 0; r < map.length; r++) {
    for (int c = 0; c < map[r].length; c++) {
      if (!visited.contains((r, c))) {
        final areaAndPerimeter = computeFencePriceForRegion(map, r, c, visited);
        fenceCost += areaAndPerimeter.area * areaAndPerimeter.sides;

        assert(areaAndPerimeter.sides.isEven, 'Sides should always be even');
      }
    }
  }

  return fenceCost;
}

/// Recursively compute the fence price for a given region.
AreaAndSides computeFencePriceForRegion(
  List<List<String>> map,
  int r,
  int c,
  Set<(int, int)> visited,
) {
  // If we've already visited this location, immediately return zero, so that
  // we don't overcount.
  if (visited.contains((r, c))) {
    return (area: 0, sides: 0);
  }

  // When processing this square, immediately count its area.
  int area = 1;
  int sides = 0;
  final plant = map[r][c];

  // Track the position so we don't count it again.
  visited.add((r, c));

  // Iterate through the cardinal directions.
  for (final direction in [(1, 0), (-1, 0), (0, 1), (0, -1)]) {
    final nextRow = r + direction.$1;
    final nextCol = c + direction.$2;

    if (nextRow >= 0 &&
        nextCol >= 0 &&
        nextRow < map.length &&
        nextCol < map[r].length &&
        map[nextRow][nextCol] == plant) {
      // If the next position is in-bounds and of the same plant type,
      // add its entire area and perimeter.
      final areaAndSize = computeFencePriceForRegion(
        map,
        nextRow,
        nextCol,
        visited,
      );
      area += areaAndSize.area;
      sides += areaAndSize.sides;
    }
  }

  bool inBounds(int x, int y) =>
      x >= 0 && y >= 0 && x < map.length && y < map[0].length;

  // The number of sides is equal to the sum of the outside corners and
  // inside corners.

  // Find all outside corners this space represents (for a single isolated
  // plant, this could be 4 outside corners).
  for (final direction in [(-1, -1), (-1, 1), (1, 1), (1, -1)]) {
    final ar = r + direction.$1;
    final ac = c + direction.$2;
    if ((!inBounds(r, ac) || map[r][ac] != plant) &&
        (!inBounds(ar, c) || map[ar][c] != plant)) {
      sides++;
    }
  }

  // Then identify all the inside corners. For a given space, this would be
  // at most one.
  for (final direction in [(1, 1), (1, -1), (-1, -1), (-1, 1)]) {
    final ar = r + direction.$1;
    final ac = c + direction.$2;
    if ((inBounds(r, ac) && map[r][ac] == plant) &&
        (inBounds(ar, c) && map[ar][c] == plant) &&
        (inBounds(ar, c) && map[ar][ac] != plant)) {
      sides++;
    }
  }

  return (area: area, sides: sides);
}
