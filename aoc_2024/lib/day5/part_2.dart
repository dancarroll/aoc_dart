import 'dart:io';

import 'shared.dart';

/// Following from Part 1, find the updates that are not valid,
/// fix them to make them valid, then find and add up all of the
/// middle numbers.
Future<int> calculate(File file) async {
  final contents = await loadData(file);

  return contents.updates
      .where((update) => !update.isValid(rules: contents.rules))
      .map((update) => update..sortViaRules(rules: contents.rules))
      .map((update) => update.middle)
      .reduce((v, e) => v + e);
}
