import 'dart:io';

import 'package:collection/collection.dart';

import 'shared.dart';

/// --- Day 6: Trash Compactor ---
///
/// Cephalopod math, where equations are given in columns with the
/// operator to use at the bottom. Evaluate each equation, and then
/// return the sum of all equations.
Future<int> calculate(File file) async {
  final equations = await loadData(file);

  return equations.map((equation) => equation.evaluate()).sum;
}
