import 'dart:io';

import 'shared.dart';

///
Future<int> calculate(File file) async {
  final input = await loadData(file);

  return input.junctions.isNotEmpty ? 0 : 1;
}
