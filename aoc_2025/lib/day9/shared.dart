import 'dart:io';
import 'dart:math';

Future<List<Point<int>>> loadData(File file) async {
  final lines = await file.readAsLines();

  final points = lines
      .map((line) => line.split(',').map(int.parse).toList())
      .map((parts) => Point(parts[0], parts[1]))
      .toList();

  return points;
}
