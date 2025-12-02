import 'dart:io';

import 'shared.dart';

const origin = Position(0, 0);

/// Continuing from Part 1, it is expected that these robots have an
/// easter egg when there should arrange themselves into a picture of
/// a Christmas tree.
///
/// Return the fewest number of seconds for the robots to demonstrate
/// this easter egg.
Future<int> calculate(File file) async {
  final data = await loadData(file);

  // Keep track of the rolling average distance of all robots from the origin.
  double averageDistance = 0;

  // Keep track of the biggest percentage drop we have seen in current
  // distance from the average, and the number of seconds it was seen.
  double biggestPercentDrop = 0;
  int biggestDropSeconds = 0;

  for (int seconds = 1; seconds < 10000; seconds++) {
    // Calculate where all the robots will be at this step.
    final newPoints = data.robots
        .map((r) => r.posAfter(seconds, height: data.height, width: data.width))
        .toList();

    // Calculate the total distance from the origin to all robots.
    final totalDistance = newPoints.fold(
      0,
      (v, e) => v + e.squaredDistanceTo(origin),
    );

    // Determine the percentage change in the current distance from the
    // rolling average.
    final percentDiffFromAverage =
        (totalDistance - averageDistance).abs() / averageDistance;

    // Only consider data points after the first few seconds, to allow the
    // average to settle.
    if (seconds > 5 && percentDiffFromAverage > biggestPercentDrop) {
      biggestPercentDrop = percentDiffFromAverage;
      biggestDropSeconds = seconds;
    }

    // Update the average given the new data point.
    averageDistance =
        ((averageDistance * (seconds - 1)) + totalDistance) / seconds;
  }

  // printMap(data, biggestDropSeconds);
  return biggestDropSeconds;
}

/// Wrapper class for [printMap], to enable it to easily update the count
/// of robots in a given position.
final class MapPos {
  int val = 0;

  @override
  String toString() => (val == 0) ? '.' : val.toString();
}

/// Builds a representation of the map at [seconds] and prints it to
/// the console.
void printMap(Data data, int seconds) {
  List<List<MapPos>> map = [];
  for (int i = 0; i < data.height; i++) {
    map.add(List.generate(data.width, (_) => MapPos()));
  }

  for (final robot in data.robots) {
    final newX = (robot.pos.x + (robot.velo.x * seconds)) % data.width;
    final newY = (robot.pos.y + (robot.velo.y * seconds)) % data.height;

    final mapPos = map[newY][newX];
    mapPos.val += 1;
  }

  StringBuffer sb = StringBuffer();
  for (final row in map) {
    sb.writeln(row.join());
  }
  print(sb.toString());
}
