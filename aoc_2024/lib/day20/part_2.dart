import 'dart:io';

import 'shared.dart';

/// Continuing from part 1, but cheats can now last up to 20 picoseconds
/// (19 squares traversed through while cheating). Unused time cannot be
/// saved for later, once the cheat is activated it will remain activated.
///
/// Cheats are identified by their starting and ending square. A different path
/// while cheating (e.g. through a block of wall tiles) does not differentiate
/// the cheats if the start and end on the same tile.
///
/// As with part 1, given this new rule, return the number of paths that will
/// save at least 100 picoseconds.
Future<int> calculate(File file) async {
  final maze = await loadData(file);

  // First, find the path with no cheat.
  final path = findSinglePath(maze);

  // Then find the savings from all cheats lasting up to 20 picoseconds.
  final savingsTarget = file.path.contains('real_data') ? 100 : 50;
  return uniqueCheatSavings(path, 20).where((x) => x >= savingsTarget).length;
}
