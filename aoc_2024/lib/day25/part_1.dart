import 'dart:io';

import 'shared.dart';

/// --- Day 25: Code Chronicle ---
///
/// Given an input of key and lock schematics, determine how many
/// unique key/lock pairs are compatible (combination of key tooth
/// height and lock pin depth is not greater than the space
/// allowed).
Future<int> calculate(File file) async {
  final data = await loadData(file);

  int numCompatiblePairs = 0;
  for (final key in data.keys) {
    for (final lock in data.locks) {
      bool compatible = true;
      for (int i = 0; i < key.length; i++) {
        if (key[i] + lock[i] > 5) {
          compatible = false;
        }
      }

      if (compatible) numCompatiblePairs++;
    }
  }

  return numCompatiblePairs;
}
