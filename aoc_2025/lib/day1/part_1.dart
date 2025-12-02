import 'dart:io';

import 'shared.dart';

/// Given a combination padlock with 100 digits (0-99), and an input file
/// listing a series of rotations (L10, R27), determine the number of times
/// the lock is left pointing at zero after a rotation.
Future<int> calculate(File file) async {
  final contents = await loadData(file);

  // Starts pointing at 50.
  int position = 50;
  int numTimesAtZero = 0;

  for (final rotation in contents) {
    position += rotation.value;
    position = position % 100;

    if (position == 0) {
      numTimesAtZero++;
    }
  }

  return numTimesAtZero;
}
