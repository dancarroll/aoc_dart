import 'dart:io';

import 'shared.dart';

/// --- Day 9: Movie Theater ---
///
Future<int> calculate(File file) async {
  final input = await loadData(file);

  return input.isNotEmpty ? 0 : 1;
}
