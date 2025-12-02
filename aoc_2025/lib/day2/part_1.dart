import 'dart:io';

import 'package:collection/collection.dart';

import 'shared.dart';

/// --- Day 2: Gift Shop ---
///
/// Given an input file containing a command-separated list of ranges
/// (start-end), find all of the numbers contained in those ranges that
/// are made up of two repeating sequences. Add up all of these numbers
/// to find the solution.
Future<int> calculate(File file) async {
  final ranges = await loadData(file);
  return ranges.map(calculateForRange).sum;
}

int calculateForRange(Range range) {
  int sumOfRepeatingNumbers = 0;

  for (int i = range.start; i <= range.end; i++) {
    final str = i.toString();
    if (str.length.isEven) {
      final midpoint = str.length ~/ 2;
      if (str.substring(0, midpoint) == str.substring(midpoint)) {
        sumOfRepeatingNumbers += i;
      }
    }
  }

  return sumOfRepeatingNumbers;
}
