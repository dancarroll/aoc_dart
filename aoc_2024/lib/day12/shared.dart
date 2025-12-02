import 'dart:io';

/// Loads a plant map from a file.
Future<List<List<String>>> loadData(File file) async {
  final lines = await file.readAsLines();
  return lines.map((l) => l.split('').toList()).toList();
}
