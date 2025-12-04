import 'dart:io';

import 'shared.dart';

/// Following from Part 1, instead of creating a voltage by picking
/// two digits from a bank, the voltage is created by picking exactly
/// 12 digits. Find the highest possible voltage for each bank, and
/// return the sum.
Future<int> calculate(File file) async {
  final input = await loadData(file);

  int sum = 0;
  for (final bank in input) {
    sum += findMaxValueForSequence(0, bank);
  }

  return sum;
}

/// The target sequence length is fixed at 12 digits.
const int sequenceLength = 12;

/// Recursive function to process the maximum value possible given
/// a current value and the remaining digits available to be used.
int findMaxValueForSequence(int curr, List<int> remaining) {
  final neededDigits = sequenceLength - curr.toString().length;
  if (neededDigits < 0) {
    return 0;
  } else if (neededDigits == 0) {
    return curr;
  }

  if (remaining.length == 1) {
    assert(neededDigits == 1, "Unexpected number of digits remaining");
    return curr * 10 + remaining[0];
  }

  // While processing this partial sequence, keep track of two values:
  // the maximum total value possible given this partial sequence, and
  // the maximum value possible when adding the next digit.
  int maxTotal = 0;
  int maxNext = 0;

  // Create new potential sequences by picking the next value. A
  // valid sequence can only be made if there will be enough remaining
  // digits later, which is why this iteration does not process over
  // the entire remaining list.

  for (int i = 0; i <= remaining.length - neededDigits; i++) {
    // Determing the value when adding the next digit.
    final potential = curr * 10 + remaining[i];

    // Given the input `curr`, we just want to find the biggest next digit to
    // add. Don't bother processing the other potential sequences.
    // This step is essential to avoid a ton of unnecessary processing that
    // would cause the solver to take a very long time to run.
    if (potential > maxNext) {
      maxNext = potential;
    } else {
      continue;
    }

    // For sequences we are processing, recursively generate the rest of the
    // sequence.
    final maxForPotential = findMaxValueForSequence(
      potential,
      remaining.sublist(i + 1),
    );

    // Store the biggest total value seen.
    if (maxForPotential > maxTotal) {
      maxTotal = maxForPotential;
    }
  }

  return maxTotal;
}
