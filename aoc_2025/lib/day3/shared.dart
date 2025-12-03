import 'dart:io';

Future<List<List<int>>> loadData(File file) async {
  final lines = await file.readAsLines();

  return lines.map((l) => l.split('').map(int.parse).toList()).toList();
}
