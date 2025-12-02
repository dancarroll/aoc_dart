import 'dart:io';

import 'shared.dart';

/// Following from part 1, but introduce a new operator:
/// concatenate (`||`).
Future<int> calculate(File file) async {
  final equations = await loadData(file);

  final result = equations
      .where(_canEquationBeTrue)
      .fold(0, (v, e) => v + e.statedResult);
  return result;
}

bool _canEquationBeTrue(final AmbiguousEquation equation) =>
    equation.canBeValid([Add(), Multiply(), Concatenation()]);
