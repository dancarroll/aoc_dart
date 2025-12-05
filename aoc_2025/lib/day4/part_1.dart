import 'dart:io';

import 'shared.dart';

/// --- Day 4: Printing Department ---
///
/// Given a map input where '.' means empty, and '@' indicates
/// a roll of paper, identify how many rolls are accessible by a
/// forklift. A roll is accessible if there are fewer than 4 rolls
/// in neighboring squares (all eight cardinal positions). Return
/// the number of accessible rolls.
Future<int> calculate(File file) async {
  final input = await loadData(file);

  int numAccessibleRolls = 0;
  for (int r = 0; r < input.length; r++) {
    for (int c = 0; c < input[0].length; c++) {
      if (input[r][c] == '.') {
        continue;
      }

      final neighbors = numNeighbors(input, r, c);
      if (neighbors < 4) {
        numAccessibleRolls++;
      }
    }
  }

  return numAccessibleRolls;
}

/// Return the number of neighbors for the given map and point.
int numNeighbors(List<List<String>> map, int r, int c) {
  return [
        (r - 1, c - 1),
        (r - 1, c),
        (r - 1, c + 1),
        (r, c - 1),
        (r, c + 1),
        (r + 1, c - 1),
        (r + 1, c),
        (r + 1, c + 1),
      ]
      .where((pos) {
        final (nr, nc) = pos;
        return nr >= 0 && nr < map.length && nc >= 0 && nc < map[0].length;
      })
      .where((pos) => map[pos.$1][pos.$2] == '@')
      .length;
}
