import 'dart:io';

import 'shared.dart';

/// Following from part 1, return the number of times the padlock ever hits
/// digit zero (either during a rotation or at the end of a rotation).
Future<int> calculate(File file) async {
  final contents = await loadData(file);

  // Starts pointing at 50.
  int position = 50;
  int numTimesAtZero = 0;

  for (final rotation in contents) {
    // Keep track of whether we are starting at zero, to avoid double
    // counting when going negative from zero.
    final wasAtZero = position == 0;

    position += rotation.value;

    if (position >= 100) {
      numTimesAtZero += (position ~/ 100).abs();
    } else if (position < 0) {
      numTimesAtZero += (position ~/ 100).abs();

      // If we didn't start at zero, count one extra.
      if (!wasAtZero) {
        numTimesAtZero++;
      }
    } else if (position == 0) {
      numTimesAtZero++;
    }

    position = position % 100;
  }

  return numTimesAtZero;
}
