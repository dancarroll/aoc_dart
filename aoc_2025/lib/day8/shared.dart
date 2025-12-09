import 'dart:io';
import 'package:vector_math/vector_math.dart';

Future<List<Vector3>> loadData(File file) async {
  final lines = await file.readAsLines();

  return lines
      .map((line) => line.split(',').map(int.parse).toList())
      .map(
        (parts) => Vector3(
          parts[0].toDouble(),
          parts[1].toDouble(),
          parts[2].toDouble(),
        ),
      )
      .toList();
}
