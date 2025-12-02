import 'dart:io';

import 'shared.dart';

/// Part 2 ups the ante to 75 blinks!
const int numBlinks = 75;

/// Following from part 1, we need to calculate 75 blinks. Due to the large
/// number of iterations and the exponential increase in the number of
/// stones, this has necessitated a different approach. The part 1 solution
/// is left as the naive solution for comparison.
Future<int> calculate(File file) async {
  final originalStones = await loadData(file);

  // Store calculation of a given value/blink pair. If we've already processed
  // a given stone at the blink number, then we should know what value it would
  // end at.
  final savedCalculations = <(int, int), int>{};

  int numStones = 0;
  for (final stone in originalStones) {
    numStones += _calculate(stone, 0, savedCalculations);
  }

  return numStones;
}

/// Calculate the number of stones that will be created starting with a stone
/// value of [stone], and [blink] number of blinks so far.
int _calculate(int stone, int blink, Map<(int, int), int> savedCalculations) {
  // After the final blink, no more stones are created, so just return 1.
  if (blink == numBlinks) {
    return 1;
  }

  // Check to see if we've already computed the number of stones that will
  // restul from this combination.
  final prev = savedCalculations[(stone, blink)];
  if (prev != null) {
    return prev;
  }

  // Otherwise, process the stone for this blink.
  final digits = numDigits(stone);
  late int val;
  if (stone == 0) {
    // Stones will value 0 turn into 1.
    val = _calculate(1, blink + 1, savedCalculations);
  } else if (digits.isEven) {
    // Stones with an even number of digits are cleaved in two.
    final (stoneLeft, stoneRight) = split(stone, digits: digits);
    val =
        _calculate(stoneLeft, blink + 1, savedCalculations) +
        _calculate(stoneRight, blink + 1, savedCalculations);
  } else {
    // Otherwise, just multiply the stone value by 2024.
    val = _calculate(stone * 2024, blink + 1, savedCalculations);
  }

  // Since we've now calculated this (stone, blink) combination, store the
  // computation for future use.
  savedCalculations[(stone, blink)] = val;
  return val;
}
