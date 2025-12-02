import 'dart:io';

import 'shared.dart';

/// --- Day 17: Chronospatial Computer ---
///
/// Emulate a 3-register, 3-bit computer.
///
/// Given the starting values for the registers (which can hold an arbitrarily
/// large value, not limited to 3 bits), and a list of instructions, run the
/// program to completion and return the output.
Future<String> calculate(File file) async {
  final computer = await loadData(file);
  return executeComputer(computer);
}

/// Executes the given computer. Exposed as a top-level function for tests.
String executeComputer(Computer computer) {
  return computer.execute().join(',');
}
