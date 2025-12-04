import 'dart:io';

import 'package:collection/collection.dart';

import 'shared.dart';

/// Following from Part 1, instead of creating a voltage by picking
/// two digits from a bank, the voltage is created by picking exactly
/// 12 digits. Find the highest possible voltage for each bank, and
/// return the sum.
Future<int> calculate(File file) async {
  final input = await loadData(file);

  int sum = 0;
  for (final bank in input) {
    sum += findMaxValueForSequence(bank);
  }

  return sum;
}

/// The target sequence length is fixed at 12 digits.
const int sequenceLength = 12;

/// Function to process the maximum value possible given a sequence
/// of digits.
int findMaxValueForSequence(List<int> sequence) {
  var remaining = sequence;
  int maxValue = 0;

  // Iterate for each of the 12 digits needed.
  for (int i = 0; i < sequenceLength; i++) {
    // We are eagerly picking the highest next digit, but need to make
    // sure there are enough digits remaining to reach 12 digits. So
    // only process the remaining digit list up to the point where we'd
    // have enough remaining digits to complete the full number.
    final validOptionsForNextDigit = remaining.sublist(
      0,
      remaining.length - 12 + i + 1,
    );

    // At each point, we just want to select the highest next digit, since
    // we are building the number from left to right. If there are multiple
    // with the same value, we select the first (left-most), as this retains
    // the most flexibility in finding the highest next digit.
    final maxDigitIndex = validOptionsForNextDigit.indexOf(
      validOptionsForNextDigit.max,
    );

    // Store this digit, and then update the remaining list to just include
    // everything after the selected digit.
    maxValue = maxValue * 10 + remaining.elementAt(maxDigitIndex);
    remaining = remaining.sublist(maxDigitIndex + 1);
  }

  return maxValue;
}
