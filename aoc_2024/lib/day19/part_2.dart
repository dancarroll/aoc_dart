import 'dart:io';

import 'package:collection/collection.dart';

import 'shared.dart';

/// Continuing from Part 1, rather than returning the number of patterns
/// that are possible, return the total number of arrangements.
///
/// For each pattern, determine how many arrangement options there are
/// given the list of towels. Return the sum of all the arrangement
/// options.
Future<int> calculate(File file) async {
  final towels = await loadData(file);

  Map<String, int> counts = {};
  return towels.patterns.map((p) => numOptions(towels.towels, p, counts)).sum;
}

/// Recursively the determines the number of combinations of [towels] that can
/// be combined to form [pattern]. Cached values per pattern are stored in
/// [counts] to improve performance.
int numOptions(List<String> towels, String pattern, Map<String, int> counts) {
  if (counts.containsKey(pattern)) {
    return counts[pattern]!;
  }

  int count = 0;
  for (final towel in towels) {
    if (towel == pattern) {
      count++;
    } else if (pattern.startsWith(towel)) {
      count += numOptions(towels, pattern.substring(towel.length), counts);
    }
  }

  counts[pattern] = count;
  return count;
}
