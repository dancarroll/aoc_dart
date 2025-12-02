import 'dart:io';

/// Loads data from file, with each line represents as
/// a string in the list.
Future<List<String>> loadData(File file) async {
  return file.readAsLines();
}
