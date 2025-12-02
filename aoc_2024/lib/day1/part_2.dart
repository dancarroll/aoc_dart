import 'dart:io';

import 'shared.dart';

/// Calculate a similarity score between two lists.
///
/// For each number in the first list, multiply the number
/// by the number of times it appears in the second list.
/// Add all of those values together.
Future<int> calculate(File file) async {
  final contents = await loadData(file);

  var result = 0;
  for (final num in contents.listA) {
    final count = contents.listB.where((i) => i == num).length;
    result += num * count;
  }
  return result;
}
