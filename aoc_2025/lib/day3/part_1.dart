import 'dart:io';

import 'package:aoc_shared/shared.dart';
import 'package:collection/collection.dart';

import 'shared.dart';

/// --- Day 3: Lobby ---
///
/// Given an input containing a set of battery banks, where each
/// digit represents one battery, for example:
/// - 811111111111119
/// - 234234234234278
///
/// Select the maximum voltage for each bank, which is the highest
/// value that can be made from any two digits, preserving their
/// order. Given the input above:
/// - 811111111111119 -> 89
/// - 234234234234278 -> 78
///
/// Calculate the sum of the highest voltage from each bank.
Future<int> calculate(File file) async {
  final input = await loadData(file);
  int sum = 0;

  for (final bank in input) {
    final options = pairs(bank).map((pair) => pair.$1 * 10 + pair.$2);
    sum += options.max;
  }

  return sum;
}
