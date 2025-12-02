import 'dart:collection';
import 'dart:io';

import 'shared.dart';

/// Continuing from part 1, determine the best instructions for selling.
/// Monkeys can only be told to sell based on the a sequence of four
/// price changes. Prices are the final digit of the secret number.
///
/// Monkeys will sell as soon as they see the specified sequence of four
/// prices.
///
/// For all the secret numbers in the input (each representing a buyer),
/// deterime the price change sequence that will result in the highest
/// total sales. It is possible that the sequence does not appear in the
/// first 2000 prices for certain buyers (which is ok, as long as the
/// total value is highest).
Future<int> calculate(File file) async {
  final data = await loadData(file);
  totalPriceForSequence.clear();

  // First, run through all 2000 numbers per buyer, during which
  // [totalPriceForSequence] will maintain the total value of sales
  // given that sequence.
  for (final start in data) {
    _simulate(start, 2000);
  }

  // Then, iterate through all of the sequences, and find the highest
  // total sales..
  int max = 0;
  for (final entry in totalPriceForSequence.entries) {
    if (entry.value > max) {
      max = entry.value;
    }
  }

  return max;
}

/// Stores the total sales price for a given sequence.
/// Each secret number simulation should only contribute once per
/// key to this map.
HashMap<(int, int, int, int), int> totalPriceForSequence = HashMap();

/// Generate the secret numbers up to [iterations], starting at
/// the given [starting] secret number. The first time each
/// sequence of four price changes is encountered, the sales price
/// is added to [totalPriceForSequence].
void _simulate(int starting, int iterations) {
  // Keep track of the sequences seen for this starting number simulation.
  Set<(int, int, int, int)> seenSequences = {};
  (int, int, int, int) trailingFourChanges = (0, 0, 0, 0);

  int secret = starting;
  int lastPrice = starting % 10;
  for (int i = 0; i < iterations; i++) {
    secret = nextSecret(secret);
    final newPrice = secret % 10;

    trailingFourChanges = (
      trailingFourChanges.$2,
      trailingFourChanges.$3,
      trailingFourChanges.$4,
      newPrice - lastPrice,
    );
    if (i >= 4) {
      // If this is the first time we have seen this sequence, add the
      // price to the sales map.
      if (!seenSequences.contains(trailingFourChanges)) {
        seenSequences.add(trailingFourChanges);

        totalPriceForSequence.update(
          trailingFourChanges,
          (x) => x + newPrice,
          ifAbsent: () => newPrice,
        );
      }
    }

    lastPrice = newPrice;
  }
}
