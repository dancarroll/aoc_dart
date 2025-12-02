import 'dart:io';
import 'dart:math' as math;

/// Loads a list of integers from a file.
Future<List<int>> loadData(File file) async {
  final lines = await file.readAsString();
  return lines.split(' ').map(int.parse).toList();
}

/// Returns the number of digits in the given integer.
///
/// Does not support integers above 15 digits.
int numDigits(final int num) => switch (num) {
  < 10 => 1,
  < 100 => 2,
  < 1000 => 3,
  < 10000 => 4,
  < 100000 => 5,
  < 1000000 => 6,
  < 10000000 => 7,
  < 100000000 => 8,
  < 1000000000 => 9,
  < 10000000000 => 10,
  < 100000000000 => 11,
  < 1000000000000 => 12,
  < 10000000000000 => 13,
  < 100000000000000 => 14,
  < 1000000000000000 => 15,
  _ => throw Exception('num $num too large'),
};

/// Splits the given [num] into two.
///
/// If [digits] is specified and non-null, it is used. If not specified,
/// the number of digits is calculated.
(int left, int right) split(int num, {int? digits}) {
  digits ??= numDigits(num);
  final midpoint = digits ~/ 2;

  final pow = math.pow(10, midpoint);
  final stoneLeft = num ~/ pow;
  final stoneRight = num - (stoneLeft * pow).toInt();

  return (stoneLeft, stoneRight);
}
