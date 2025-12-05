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
  final map = await loadData(file);
  return map.points.where(map.isAccessible).length;
}
