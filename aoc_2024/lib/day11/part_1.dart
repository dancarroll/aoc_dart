import 'dart:io';

import 'shared.dart';

/// Part 1 is 25 blinks.
const int numBlinks = 25;

/// --- Day 11: Plutonian Pebbles ---
///
/// Given a list of magical stones with values, determine how many stones
/// are present after blinking 25 times.
///
/// Every time you blink, each of the stones changes, according to the
/// following rules. Each stone is transformed with only the first
/// applicable rule per blink.
/// - Stone with value 0 is changed to 1
/// - Stone wtih an even number of digits is split in two (1234 -> 12, 34)
/// - Stone value is multiplied by 2024
Future<int> calculate(File file) async {
  final stones = await loadData(file);

  for (int i = 0; i < numBlinks; i++) {
    final numStones = stones.length;
    for (int j = 0; j < numStones; j++) {
      final stone = stones[j];
      final digits = numDigits(stone);
      if (stone == 0) {
        stones[j] = 1;
      } else if (digits.isEven) {
        final (stoneLeft, stoneRight) = split(stone, digits: digits);

        stones[j] = stoneLeft;
        stones.add(stoneRight);
      } else {
        stones[j] = stone * 2024;
      }
    }
  }

  return stones.length;
}
