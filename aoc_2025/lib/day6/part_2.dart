import 'dart:io';

import 'package:collection/collection.dart';

import 'shared.dart';

/// Following from part 1, we found out that the numbers need
/// to be read top-down, rather than left-to-right. So,
///
/// 123
///  45
///   6
/// *
///
/// Is actually 1 * 24 * 356.
///
/// Parse all of the equations, and return the sum of adding
/// all of the results.
Future<int> calculate(File file) async {
  final equations = await loadData(file);

  return equations.map((equation) => equation.evaluate()).sum;
}

Future<List<Equation>> loadData(File file) async {
  final lines = await file.readAsLines();
  List<Equation> equations = [];

  // Keep track of the operands and operator for the current
  // equation.
  List<int> operands = [];
  Operator operator = Operator.unknown;

  // Iterate through each column.
  for (int c = 0; c < lines[0].length; c++) {
    // Build the operands by append each character in the
    // column, excluding the last row which would contain
    // the operator.
    StringBuffer sb = StringBuffer();
    for (int r = 0; r < lines.length - 1; r++) {
      sb.write(lines[r][c]);
    }

    // Attempt to parse the operator character from the last row.
    final operatorChar = lines[lines.length - 1][c].trim();
    if (operatorChar.isNotEmpty) {
      operator = Operator.fromString(operatorChar);
    }

    // Now, try and parse the operand characters into an integer.
    // If it's a valid integer, add it to the stored operands for
    // the current equation.
    final operandStr = sb.toString();
    final maybeOperand = int.tryParse(operandStr);
    if (maybeOperand != null) {
      operands.add(maybeOperand);
    }

    // Check to see if this equation is finished, either due to an empty
    // column (no operand), or we are on the last column.
    if (maybeOperand == null || c == lines[0].length - 1) {
      // Ensure we actually have operands and a valid operator.
      assert(operands.isNotEmpty, "Unexpected empty operands");
      assert(operator != Operator.unknown, 'Unexpected operator');

      // Add the finished equation to the list, and clear out the stored
      // operands and operator in preparation for starting to parse the
      // next equation.
      equations.add(Equation(operands, operator));
      operands = [];
      operator = Operator.unknown;
    }
  }

  return equations;
}
