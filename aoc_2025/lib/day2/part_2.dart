import 'dart:io';

import 'package:collection/collection.dart';

import 'shared.dart';

/// Following from part 1, instead of looking for a number made up of
/// only two repeating sequences, sequences can be any length:
///
/// Examples:
/// - 12341234 (1234 two times)
/// - 123123123 (123 three times)
/// - 1212121212 (12 five times)
/// - 1111111 (1 seven times)
///
/// Find all of the numbers that match these rules, and return the sum.
Future<int> calculate(File file) async {
  final ranges = await loadData(file);
  return ranges.map(calculateForRange).sum;
}

/// Calculates the sum of all numbers in the given range that are just a
/// repeating sequence of digits.
int calculateForRange(Range range) {
  int sumOfRepeatingNumbers = 0;

  for (int i = range.start; i <= range.end; i++) {
    if (doesNumberConsistentOfRepeatingSequences(i)) {
      sumOfRepeatingNumbers += i;
    }
  }

  return sumOfRepeatingNumbers;
}

/// Determines if the given number consists only of a repeating sequence
/// of digits.
bool doesNumberConsistentOfRepeatingSequences(int num) {
  final str = num.toString();

  // Iterate through all the sequence lengths. The max sequence length
  // would be half the length of the number (two sequences repeating).
  for (int seqLen = 1; seqLen <= str.length ~/ 2; seqLen++) {
    // Ensure the sequence length can split up the number into equal size
    // chunks.
    if (str.length % seqLen > 0) {
      continue;
    }

    // Start by finding the target sequence.
    final targetSeq = str.substring(0, seqLen);

    // Now iterate through each block in the number.
    bool isMatch = true;
    for (int i = seqLen; i <= str.length - seqLen; i += seqLen) {
      if (str.substring(i, i + seqLen) != targetSeq) {
        isMatch = false;
        break;
      }
    }

    // If this number has already produced a match with the current
    // sequence, return true immediately.
    if (isMatch) {
      return true;
    }
  }

  return false;
}
