import 'dart:io';

Future<List<String>> loadData(File file) async {
  final lines = await file.readAsLines();

  return lines;
}
