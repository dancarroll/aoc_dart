import 'dart:io';

import 'paths.dart';
import 'shared.dart';

/// --- Day 16: Reindeer Maze ---
///
/// Reindeer Maze during the Reindeer Olympics!
///
/// Given a maze layout, and a cost to move through the maze (1 point for
/// going straight, 1000 points for a turn), compute the lowest cost path
/// from the start position to the end position. Return that cost.
Future<int> calculate(File file) async {
  final maze = await loadData(file);
  return findBestPath(maze).score;
}
