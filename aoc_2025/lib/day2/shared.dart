import 'dart:io';

/// Represents a range of values.
final class Range {
  /// The stat of the range, inclusive.
  final int start;

  /// The end of the range, inclusive.
  final int end;

  Range(this.start, this.end);

  /// Parse the range from a string input: "start-end"
  factory Range.parse(final String input) {
    final parts = input.split('-');
    final start = int.parse(parts[0]);
    final end = int.parse(parts[1]);

    return Range(start, end);
  }
}

Future<List<Range>> loadData(File file) async {
  final lines = await file.readAsLines();
  final ranges = lines[0].split(',');

  return ranges.map(Range.parse).toList();
}
