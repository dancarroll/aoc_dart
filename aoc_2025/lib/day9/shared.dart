import 'dart:collection';
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

final class Floor {
  final Set<Point<int>> redTiles;
  final Set<Point<int>> borderTiles;
  final CapturedRegion capturedRegion;

  Floor(this.redTiles, this.borderTiles, this.capturedRegion);
}

Future<Floor> loadFloor(File file) async {
  final redTiles = await loadData(file);
  final borderTiles = redTiles.toSet();

  Point<int> lastPos = redTiles[0];
  for (int i = 1; i < redTiles.length; i++) {
    final currPos = redTiles[i];

    print('Filling in edge points: $i');
    borderTiles.addAll(allPointsBetween(lastPos, currPos));
    lastPos = currPos;
  }
  print('Filling in last edge');
  borderTiles.addAll(allPointsBetween(lastPos, redTiles[0]));

  print('Finding the contained points');
  final capturedRegion = findContainedPoints(borderTiles);

  return Floor(redTiles.toSet(), borderTiles, capturedRegion);
}

Set<Point<int>> allPointsBetween(Point<int> a, Point<int> b) {
  final points = <Point<int>>{};
  final vector = b - a;

  int x = vector.x, y = vector.y;
  bool processedXAtZero = false;
  do {
    bool processedYAtZero = false;
    do {
      final newPoint = a + Point(x, y);
      points.add(newPoint);

      if (y == 0) {
        processedYAtZero = true;
      } else {
        if (vector.y > 0) {
          y--;
        } else if (vector.y < 0) {
          y++;
        }
      }
    } while (!processedYAtZero);

    y = vector.y;

    if (x == 0) {
      processedXAtZero = true;
    } else {
      if (vector.x > 0) {
        x--;
      } else if (vector.x < 0) {
        x++;
      }
    }
  } while (!processedXAtZero);

  return points;
}

/// Efficiently represents a large set of captured points using
/// Run-Length Encoding.
class CapturedRegion extends Iterable<Point<int>> {
  // Store data as: Map<Y, List<(StartX, EndX)>>
  final Map<int, List<(int, int)>> _spans;
  int _count = -1; // Lazy cache for length

  CapturedRegion(this._spans);

  /// Check if a point is captured in O(log N) time (very fast).
  @override
  bool contains(Object? element) {
    if (element is! Point<int>) return false;
    final spans = _spans[element.y];
    if (spans == null) return false;

    // Binary search could be used here for extra speed,
    // but linear scan is fast enough for typical fragmentation.
    for (final (start, end) in spans) {
      if (element.x >= start && element.x <= end) return true;
    }
    return false;
  }

  /// Total number of captured points. Calculated instantly without iterating.
  @override
  int get length {
    if (_count == -1) {
      _count = 0;
      for (final list in _spans.values) {
        for (final (start, end) in list) {
          _count += (end - start + 1);
        }
      }
    }
    return _count;
  }

  @override
  Iterator<Point<int>> get iterator => _generatePoints().iterator;

  Iterable<Point<int>> _generatePoints() sync* {
    for (final entry in _spans.entries) {
      final y = entry.key;
      for (final (start, end) in entry.value) {
        for (int x = start; x <= end; x++) {
          yield Point(x, y);
        }
      }
    }
  }
}

CapturedRegion findContainedPoints(Set<Point<int>> borderPoints) {
  if (borderPoints.isEmpty) return CapturedRegion({});

  // 1. Pre-process Border: Organize by Row (Y) and Sort X for fast lookups.
  // This allows us to detect walls instantly.
  int minX = 2147483647, maxX = -2147483648;
  int minY = 2147483647, maxY = -2147483648;

  final borderMap = <int, Set<int>>{};

  for (final p in borderPoints) {
    if (p.x < minX) minX = p.x;
    if (p.x > maxX) maxX = p.x;
    if (p.y < minY) minY = p.y;
    if (p.y > maxY) maxY = p.y;

    borderMap.putIfAbsent(p.y, () => {}).add(p.x);
  }

  // 2. Scanline Flood Fill (Outside-In)
  // We define a padding of 1 around the bounding box to ensure flow.
  final rangeMinX = minX - 1;
  final rangeMaxX = maxX + 1;
  final rangeMinY = minY - 1;
  final rangeMaxY = maxY + 1;

  // Track "Outside" areas as spans to save memory.
  final outsideSpans = <int, List<(int, int)>>{};

  // Helper to check if a range overlaps with existing outside spans
  bool isRangeVisited(int y, int start, int end) {
    final spans = outsideSpans[y];
    if (spans == null) return false;
    for (final (s, e) in spans) {
      // If the new range is completely inside a known safe span
      if (start >= s && end <= e) return true;
    }
    return false;
  }

  // Helper to add a span to the visited set
  void addVisitedSpan(int y, int start, int end) {
    // Simple insertion (Merging adjacent spans could optimize further,
    // but implies overhead).
    outsideSpans.putIfAbsent(y, () => []).add((start, end));
  }

  final queue = Queue<(int, int)>(); // Seeds (x, y)

  // Seed the top-left corner (which we know is outside due to padding)
  queue.add((rangeMinX, rangeMinY));

  while (queue.isNotEmpty) {
    if (queue.length % 10 == 0) {
      print('Queue length: ${queue.length}');
    }
    final (seedX, seedY) = queue.removeFirst();

    // If this specific seed is already processed, skip
    // (We check efficiently using the spans).
    if (isRangeVisited(seedY, seedX, seedX)) continue;

    // 1. SCAN HORIZONTALLY
    // Expand left and right from the seed until we hit a border or bounds.
    int left = seedX;
    while (left > rangeMinX) {
      final borderRow = borderMap[seedY];
      // Check if left-1 is a border
      if (borderRow != null && borderRow.contains(left - 1)) break;
      // Optimization: Using binary search on borderRow is faster for huge
      // borders
      left--;
    }

    int right = seedX;
    while (right < rangeMaxX) {
      final borderRow = borderMap[seedY];
      if (borderRow != null && borderRow.contains(right + 1)) break;
      right++;
    }

    // Mark this entire horizontal line as Outside
    addVisitedSpan(seedY, left, right);

    // 2. SCAN VERTICALLY (Queue neighbors)
    // Check rows above and below for new seeds
    for (final nextY in [seedY - 1, seedY + 1]) {
      if (nextY < rangeMinY || nextY > rangeMaxY) continue;

      final borderRow = borderMap[nextY] ?? const {};
      // We scan the range [left, right] on the adjacent row
      // We want to add ONE seed for every contiguous empty segment.

      bool inGap = false;
      for (int x = left; x <= right; x++) {
        // Is this pixel a wall?
        // (Binary search would be better here for massive borders,
        // but .contains is okay for typical usage)
        final isWall = borderRow.contains(x);

        // Also check if we already visited this x,y (optimization)
        final isVisited = isRangeVisited(nextY, x, x);

        if (!isWall && !isVisited) {
          if (!inGap) {
            inGap = true;
            queue.add((x, nextY)); // Found start of a gap
          }
        } else {
          inGap = false; // Hit a wall or visited area
        }
      }
    }
  }

  // 3. Invert the Result
  // Captured = (Bounding Box) - (Border) - (Outside)
  final capturedSpans = <int, List<(int, int)>>{};

  for (int y = minY; y <= maxY; y++) {
    // Start with the full width of the row inside bounds
    // We treat the row as a collection of "Available" ranges.
    // Initially, it's just one range: [minX, maxX]
    // We subtract Borders and OutsideSpans from it.

    // Simplified boolean array approach for the row finalization
    // Since we process row-by-row, we only allocate one row's worth of memory
    // at a time.
    final width = maxX - minX + 1;
    if (width <= 0) continue;

    final rowIsCaptured = List<bool>.filled(width, true);

    // Mark borders as NOT captured
    if (borderMap.containsKey(y)) {
      for (final bx in borderMap[y]!) {
        if (bx >= minX && bx <= maxX) {
          rowIsCaptured[bx - minX] = false;
        }
      }
    }

    // Mark outside as NOT captured
    if (outsideSpans.containsKey(y)) {
      for (final (start, end) in outsideSpans[y]!) {
        final clampStart = max(start, minX);
        final clampEnd = min(end, maxX);
        for (int x = clampStart; x <= clampEnd; x++) {
          rowIsCaptured[x - minX] = false;
        }
      }
    }

    // Convert the boolean row back into Spans
    int? currentStart;
    for (int i = 0; i < width; i++) {
      if (rowIsCaptured[i]) {
        currentStart ??= (minX + i);
      } else {
        if (currentStart != null) {
          capturedSpans.putIfAbsent(y, () => []).add((
            currentStart,
            (minX + i - 1),
          ));
          currentStart = null;
        }
      }
    }
    if (currentStart != null) {
      capturedSpans.putIfAbsent(y, () => []).add((currentStart, maxX));
    }
  }

  return CapturedRegion(capturedSpans);
}
