import 'dart:io';
import 'dart:math';

import 'shared.dart';

/// Computes what the indicator lights should look like when the given
/// [joltages] are reached.
List<bool> parityIndicators(List<int> joltages) =>
    joltages.map((joltage) => joltage.isOdd).toList();

/// Following from part 1, rather than needing to hit the target indicator
/// lights, we need to hit the target joltages (the last part of the input,
/// ignored in part 1). Joltages are modified following the same pattern as
/// the indicator lights, but unlike part 1 we expect to press buttons more
/// than once in order to reach higher joltage values.
Future<int> calculate(File file) async {
  final machines = await loadData(file);

  int totalPresses = 0;
  for (final machine in machines) {
    // Great insight found on Reddit from /u/tenthmascot:
    // https://www.reddit.com/r/adventofcode/comments/1pk87hl/comment/ntp4njq/
    //
    // We can narrow the search space by interpreting button combinations in
    // terms of indicator lights. If an indicator light is flipped an odd number
    // of times, it is on. If it is flipped an even number of times, it would be
    // off.
    final cachedValues = <String, int>{};
    totalPresses += minPressesToHitTargetJoltage(
      machine.joltages,
      machine,
      cachedValues,
    );
  }

  return totalPresses;
}

/// Calculate the minimum number of presses needed to hit the specified joltage
/// targets for the given [machine]. [cachedValues] should inititally be an
/// empty map, and is used to avoid recalculating the same path across multiple
/// branches.
int minPressesToHitTargetJoltage(
  List<int> joltageRemaining,
  Machine machine,
  Map<String, int> cachedValues,
) {
  final cacheKey = joltageRemaining.join(',');
  final cachedValue = cachedValues[cacheKey];
  if (cachedValue != null) {
    return cachedValue;
  }

  if (joltageRemaining.every((joltage) => joltage == 0)) {
    return 0;
  }
  if (joltageRemaining.any((joltage) => joltage < 0)) {
    return 1_000_000;
  }

  /// Choose a value bigger than the actual expected solution range, but low
  /// enough that it will not overflow when adding/multiplying across recursive
  /// calls.
  int minPresses = 1_000_000;

  // Great insight found on Reddit from /u/tenthmascot:
  // https://www.reddit.com/r/adventofcode/comments/1pk87hl/comment/ntp4njq/
  //
  // We can narrow the search space by interpreting button combinations in
  // terms of indicator lights. If an indicator light is flipped an odd number
  // of times, it is on. If it is flipped an even number of times, it would be
  // off.
  for (final combination in machine.buttonCombinationsToReachIndicators(
    parityIndicators(joltageRemaining),
  )) {
    /// Press the button combination, and determine what joltage remains.
    final newJoltages = machine.reduceJoltageTargetFromPresses(
      joltageRemaining,
      combination,
    );

    /// Another inside from Reddit: because we have normalized based on the
    /// parity indicators, the resulting joltages should all be even. Thus,
    /// we can divide by two to reduce the recursion necessary (though note
    /// that we multiply the recursive result by 2 below).
    final newJoltagesNormalized = newJoltages
        .map((joltage) => joltage ~/ 2)
        .toList();

    final result =
        // Count the buttons pressed in the combination being processed.
        combination.length +
        // Recursively call this function for the new target joltage remaining.
        minPressesToHitTargetJoltage(
              newJoltagesNormalized,
              machine,
              cachedValues,
            ) *
            // This gets multiplied by two, because we divided the target
            // joltages by 2 above.
            2;

    /// Update min presses if needed.
    minPresses = min(minPresses, result);
  }

  cachedValues[cacheKey] = minPresses;
  return minPresses;
}
