import 'dart:io';

import 'shared.dart';

/// Continuing from Part 1, it was determined that the program is expected
/// to produce output that matches the program itself. The given value for
/// register A is corrupted. Determine the lowest value for register A, such
/// that the program outputs itself.
Future<int> calculate(File file) async {
  final computer = await loadData(file);

  return solve(computer);
}

/// Solves the problem for the given computer. This is split out from [compute]
/// in order to be used from tests with input not defined in a file.
int solve(Computer computer) {
  final expectedOutput = computer.serializedInstructions
      .split(',')
      .map(int.parse)
      .toList();

  final foundA = findA(computer, 0, expectedOutput);
  assert(foundA != null, 'Did not find an answer');
  return foundA!;
}

/// Recursively finds the value such that the program produces the given
/// target output. This function works backwards (least significant bits first).
int? findA(Computer computer, int a, List<int> targetOutput) {
  // If there are no numbers remaining in the target list, we have found
  // the correct value of A.
  if (targetOutput.isEmpty) {
    return a;
  }

  // Iterate through the possible options for the next three bits (since this
  // is a 3-bit computer).
  for (final nextTriad in List.generate(8, (i) => i)) {
    // Multiple the current value of A by 8, to shift it up three bits.
    final potentialA = a * 8 + nextTriad;

    // Compute the value of the program with this potential value of A.
    //final outputTriad = computeB(potentialA);
    final testComputer = Computer.withOverrideA(computer, potentialA);
    final outputTriad = testComputer.execute(allowJumps: false).last;

    // If this value matches, recursively call this function for the next
    // value in the output.
    if (outputTriad == targetOutput.last) {
      final branchA = findA(
        computer,
        potentialA,
        targetOutput.sublist(0, targetOutput.length - 1),
      );
      if (branchA != null) {
        return branchA;
      }
    }
  }

  return null;
}
