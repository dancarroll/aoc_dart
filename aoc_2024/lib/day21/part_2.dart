import 'dart:io';

import 'shared.dart';
import 'sequences.dart';

/// Continuing from part 1 -- instead of 2 robots with directional keypads,
/// there are actually 25!
///
/// You -> Robot 1 -> ... -> Robot 25 -> Robot 26 (numeric keypad).
///
/// Return value is the same as before (sum of complexities).
Future<int> calculate(File file) async {
  final data = await loadData(file);
  return totalComplexityForCodes(data, numDirectionalKeypads: 25);
}
