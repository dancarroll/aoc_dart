import 'dart:io';

Future<List<List<String>>> loadData(File file) async {
  final lines = await file.readAsLines();
  return lines.map((l) => l.split('').toList()).toList();
}
