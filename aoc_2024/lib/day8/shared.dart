import 'dart:io';
import 'dart:math';

import 'package:aoc_shared/shared.dart';

typedef Location = Point<int>;

/// Represents frequencies being broadcast from antennas within a map.
final class FrequencyMap {
  /// Map of frequenct to locations with an antenna broadcasting that
  /// frequency.
  final Map<String, List<Location>> antennaLocations;

  /// Height bound of the map.
  final int height;

  /// Width bound of the map.
  final int width;

  FrequencyMap({
    required this.antennaLocations,
    required this.height,
    required this.width,
  });

  /// Returns true if the given location fits within the bounds of
  /// the map.
  bool inBounds(final Location location) {
    return location.x >= 0 &&
        location.x < height &&
        location.y >= 0 &&
        location.y < width;
  }

  /// Generates a list of all antinodes for this map. Antinodes are points
  /// in which the broadcast from two antennas of the same frequency are
  /// amplified.
  ///
  /// If [includeHarmonics] is false, this will generate two antinodes per
  /// pair of antennas on the same frequency. The antinodes will be on either
  /// side of each antenna, where one antinode is twice as far from one antenna.
  ///
  /// If [includeHarmonics] is true, this will generate all antinodes along the
  /// straightline path between two antennas. Each antinode is spaced out
  /// according to the distance between the two antennas.
  Set<Location> antinodes({bool includeHarmonics = false}) {
    Set<Location> antinodes = {};

    for (final antennaLocations in antennaLocations.values) {
      for (final pair in pairs(antennaLocations)) {
        antinodes.addAll(
          _generateAntinodesUntilOutOfBounds(
            a: pair.$1,
            b: pair.$2,
            includeHarmonics: includeHarmonics,
          ),
        );
      }
    }

    return antinodes;
  }

  /// Generates the list of antinodes for a single pair of antenna locations.
  /// See [antinodes] for a description of the generation.
  Set<Location> _generateAntinodesUntilOutOfBounds({
    required Location a,
    required Location b,
    required bool includeHarmonics,
  }) {
    final hop = a - b;
    Set<Location> locations = {};

    final List<({Location starting, Location Function(Location) hopFunc})>
    directionFunctions = [
      (starting: a, hopFunc: (l) => l + hop),
      (starting: a, hopFunc: (l) => l - hop),
      (starting: b, hopFunc: (l) => l + hop),
      (starting: b, hopFunc: (l) => l - hop),
    ];

    for (final direction in directionFunctions) {
      var addedOneAntinode = false;
      var next = direction.hopFunc(direction.starting);
      while (
      // If not including all harmonics, only process this loop until
      // an antinode has been added.
      (includeHarmonics || !addedOneAntinode) &&
          // The two antenna locations themselves are only eligible to
          // be considered antinodes when including all harmonics.
          (includeHarmonics || (next != a && next != b)) &&
          // Stop processing when encountering an out-of-bounds
          // location.
          inBounds(next) &&
          // If a location has already been seen, we can stop processing.
          // This is because [directionFunctions] will attempt to process
          // each direction from both antenna locations. This allows us to
          // avoid figuring out which direction to travel from a given
          // antenna, but avoid processing the same locations twice.
          !locations.contains(next)) {
        locations.add(next);
        addedOneAntinode = true;
        next = direction.hopFunc(next);
      }
    }

    return locations;
  }
}

/// Loads data from file, which is a map of frequency to
/// locations (points on a map).
Future<FrequencyMap> loadData(File file) async {
  final lines = await file.readAsLines();

  Map<String, List<Location>> frequencies = {};

  for (int r = 0; r < lines.length; r++) {
    final line = lines[r];
    for (int c = 0; c < line.length; c++) {
      if (line[c] == '.') {
        continue;
      }

      final frequency = frequencies.putIfAbsent(line[c], () => []);
      frequency.add(Location(r, c));
    }
  }

  return FrequencyMap(
    antennaLocations: frequencies,
    height: lines.length,
    width: lines[0].length,
  );
}
