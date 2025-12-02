import 'dart:io';

import 'shared.dart';

/// Given a list of equations without operators, determine which
/// equations could be valid, and return the sum of all equations
/// which could be valid.
///
/// Equations are given of the form:
/// 3267: 81 40 27
///
/// The first value is the equation result, and the remaining value
/// are the equation operands. The only valid operators are add (`+`)
/// and multiply (`*`).
Future<int> calculate(File file) async {
  final equations = await loadData(file);

  final result = equations
      .where(_canEquationBeTrue)
      .fold(0, (v, e) => v + e.statedResult);
  return result;
}

bool _canEquationBeTrue(final AmbiguousEquation equation) =>
    equation.canBeValid([Add(), Multiply()]);
