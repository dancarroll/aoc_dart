import 'dart:io';

import 'shared.dart';

typedef AreaAndSize = ({int area, int perimeter});

/// --- Day 12: Garden Groups ---
///
/// Given the layout of garden, where each plant is represented by a letter,
/// determine how expensive it would be to fence in each plot.
///
/// Fence cost is determined multiplying the area of a plot (number of plants)
/// by the perimeter of the plot (number of lines that would need to be drawn
/// to contain it). Return the sum of all of the fence costs.
Future<int> calculate(File file) async {
  final visited = <(int, int)>{};
  final map = await loadData(file);

  int fenceCost = 0;
  for (int r = 0; r < map.length; r++) {
    for (int c = 0; c < map[r].length; c++) {
      if (!visited.contains((r, c))) {
        final areaAndPerimeter = computeFencePriceForRegion(map, r, c, visited);
        fenceCost += areaAndPerimeter.area * areaAndPerimeter.perimeter;

        assert(
          areaAndPerimeter.perimeter.isEven,
          'Perimeter should always be even',
        );
      }
    }
  }

  return fenceCost;
}

/// Recursively compute the fence price for a given region.
AreaAndSize computeFencePriceForRegion(
  List<List<String>> map,
  int r,
  int c,
  Set<(int, int)> visited,
) {
  // If we've already visited this location, immediately return zero, so that
  // we don't overcount.
  if (visited.contains((r, c))) {
    return (area: 0, perimeter: 0);
  }

  // When processing this square, immediately count its area.
  int area = 1;
  int perimeter = 0;
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
      perimeter += areaAndSize.perimeter;
    } else {
      // Otherwise, this is an edge, so increment the perimeter by 1,
      perimeter += 1;
    }
  }

  return (area: area, perimeter: perimeter);
}
