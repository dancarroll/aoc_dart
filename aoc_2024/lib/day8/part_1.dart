import 'dart:io';

import 'shared.dart';

/// Find the number of antinodes from a map of antenna locations.
///
/// An antinode occurs at any point that is perfectly in line with two
/// antennas of the same frequency - but only when one of the antennas
/// is twice as far away as the other.
///
/// This function should return the number of locations on the map that
/// are antinodes (some locations may be antinodes for multiple
/// frequencies, so only count those once).
Future<int> calculate(File file) async {
  final frequencyMap = await loadData(file);
  return frequencyMap.antinodes(includeHarmonics: false).length;
}
