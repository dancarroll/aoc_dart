import 'dart:io';

import 'package:collection/collection.dart';

import 'shared.dart';

/// Alternate Part 2 solution using regular expressions.
Future<int> calculate(File file) async {
  final ranges = await loadData(file);
  return ranges.map(calculateForRange).sum;
}

/// Regex that looks for a repeating sequence of any number of digits.
/// The sequence must appear at least two times (`\1+` is the backreference
/// to the first group, need to match one or more times).
final repeatingSequenceRegex = RegExp(r'^(\d+)\1+$');

/// Calculates the sum of all numbers in the given range that are just a
/// repeating sequence of digits.
int calculateForRange(Range range) {
  int sumOfRepeatingNumbers = 0;

  for (int i = range.start; i <= range.end; i++) {
    if (repeatingSequenceRegex.hasMatch(i.toString())) {
      sumOfRepeatingNumbers += i;
    }
  }

  return sumOfRepeatingNumbers;
}
