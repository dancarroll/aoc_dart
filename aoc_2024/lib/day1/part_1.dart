import 'dart:io';

import 'shared.dart';

/// Calculate the difference between two lists, by sorting
/// each list and adding up the difference of each pair.
Future<int> calculate(File file) async {
  final contents = await loadData(file);
  assert(
    contents.listA.length == contents.listB.length,
    'Based on the input, always expect these two lists to be the same size',
  );

  var diff = 0;
  for (var i = 0; i < contents.listA.length; i++) {
    diff += (contents.listA[i] - contents.listB[i]).abs();
  }
  return diff;
}
