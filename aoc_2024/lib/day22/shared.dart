import 'dart:io';

/// Calculates the next secret number after the given [secret].
int nextSecret(int secret) {
  int next = secret;
  next = ((next * 64) ^ next) % 16777216;
  next = ((next ~/ 32) ^ next) % 16777216;
  return ((next * 2048) ^ next) % 16777216;
}

/// Loads the list of starting secret numbers.
Future<List<int>> loadData(File file) async {
  final lines = await file.readAsLines();
  return lines.map(int.parse).toList();
}
