import 'dart:io';

enum Direction { left, right }

final class Rotation {
  final Direction direction;
  final int clicks;

  Rotation(this.direction, this.clicks);

  factory Rotation.fromString(final String input) {
    final direction = input[0] == 'L' ? Direction.left : Direction.right;
    final clicks = int.parse(input.substring(1));
    return Rotation(direction, clicks);
  }

  int get value => switch (direction) {
    Direction.left => 0 - clicks,
    Direction.right => 0 + clicks,
  };

  @override
  String toString() => '$direction$clicks';
}

Future<List<Rotation>> loadData(File file) async {
  final lines = await file.readAsLines();

  return lines.map(Rotation.fromString).toList();
}
