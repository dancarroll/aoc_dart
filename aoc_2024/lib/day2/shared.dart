import 'dart:io';

/// Represents a single report, which is a sequence of
/// integers (levels).
final class Report {
  final List<int> levels;

  Report(this.levels) {
    assert(levels.length > 1, 'Report needs at least one level');
  }

  /// Returns true if the report is "safe", which means the
  /// sequence of numbers only ever goes in one direction
  /// (increasing or decreasing), and never changes more than
  /// 3 in any single jump.
  bool isSafe() {
    int? comp;
    var last = levels[0];

    for (var i = 1; i < levels.length; i++) {
      // Any jump greater than 3 is unsafe.
      if ((last - levels[i]).abs() > 3) {
        return false;
      }

      // Ensure values only ever increase or decrease, based on the
      // initial change.
      var result = last.compareTo(levels[i]);
      if (comp == null && comp != 0) {
        comp = result;
        last = levels[i];
      } else if (comp == result) {
        last = levels[i];
      } else {
        return false;
      }
    }

    return true;
  }

  /// Tests whether this report would be considered safe if any single
  /// level was removed.
  bool isSafeWithOneRemovedLevel() {
    for (var i = 0; i < levels.length; i++) {
      final testLevels = List<int>.from(levels);
      testLevels.removeAt(i);

      if (Report(testLevels).isSafe()) {
        return true;
      }
    }

    return false;
  }
}

/// Loads data from file, parses the values into integers.
Future<Iterable<Report>> loadData(File file) async {
  final lines = await file.readAsLines();

  return lines
      .map((line) => line.split(' ').map(int.parse))
      .map((levels) => Report(levels.toList()));
}
