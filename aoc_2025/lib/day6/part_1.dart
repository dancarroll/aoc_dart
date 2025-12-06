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

Future<List<Equation>> loadData(File file) async {
  final lines = await file.readAsLines();
  List<Equation> equations = [];

  for (final line in lines) {
    final parts = line.split(' ').whereNot((s) => s.isEmpty).toList();

    for (int i = 0; i < parts.length; i++) {
      if (equations.length <= i) {
        equations.add(Equation.empty());
      }

      final equation = equations[i];

      final maybeInt = int.tryParse(parts[i]);
      if (maybeInt == null) {
        equation.operator = Operator.fromString(parts[i]);
      } else {
        equation.operands.add(maybeInt);
      }
    }
  }

  return equations;
}
