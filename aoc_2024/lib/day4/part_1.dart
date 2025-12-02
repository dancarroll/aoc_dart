import 'dart:io';

import 'shared.dart';

/// Word search: find the number of times 'XMAS' appears
/// in a grid. The word can appear in any direction (e.g.
/// forward, backward, diagonal, etc).
Future<int> calculate(File file) async {
  final lines = await loadData(file);
  return _calculate(lines);
}

int _calculate(List<String> lines) {
  var result = 0;
  for (var r = 0; r < lines.length; r++) {
    final line = lines[r];
    for (var c = 0; c < line.length; c++) {
      result += _calculatePosition(lines, r, c);
    }
  }

  return result;
}

int _calculatePosition(List<String> lines, int row, int col) {
  final line = lines[row];
  final char = line[col];

  // Only check spaces that begin with an 'X'.
  if (char != 'X') {
    return 0;
  }

  // Calculate all directions: forward, backward, up, down, and the four
  // diagonals.
  final directions = [-1, 0, 1];
  var result = 0;
  for (var i = 0; i < directions.length; i++) {
    for (var j = 0; j < directions.length; j++) {
      result += _calculateDirection(
        lines: lines,
        row: row,
        col: col,
        rowDir: directions[i],
        colDir: directions[j],
      );
    }
  }
  return result;
}

int _calculateDirection({
  required final List<String> lines,
  required final int row,
  required final int col,
  required final int rowDir,
  required final int colDir,
}) {
  if (rowDir == 0 && colDir == 0) return 0;

  var r = row, c = col;
  final buf = StringBuffer();
  while (buf.length < 4 &&
      r >= 0 &&
      r < lines.length &&
      c >= 0 &&
      c < lines[0].length) {
    buf.write(lines[r][c]);
    r += rowDir;
    c += colDir;
  }

  return (buf.toString() == 'XMAS') ? 1 : 0;
}
