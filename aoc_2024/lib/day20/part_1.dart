import 'dart:io';

import 'shared.dart';

/// --- Day 20: Race Condition ---
///
/// Maze puzzle, except that it is possible to "cheat" by passing through
/// one wall segment. Find the number of cheats that would result in a
/// 100 picosecond savings over the path with no cheats (each step counts as
/// 1 picosecond).
///
/// Note: the maze input to this solution doesn't have any branching, so there
/// is only a single valid path without cheats.
Future<int> calculate(File file) async {
  final maze = await loadData(file);

  // First, find the path with no cheat.
  final path = findSinglePath(maze);

  // Then find the savings from all cheats lasting up to 2 picoseconds.
  final savingsTarget = file.path.contains('real_data') ? 100 : 20;
  return uniqueCheatSavings(path, 2).where((x) => x >= savingsTarget).length;
}
