import 'dart:io';

import 'shared.dart';

/// Word search looking where two instances of 'MAS' appear
/// crossed on the diagonal (X-MAS), e.g. an X shaped
/// centered on the 'A' letter.
///
/// ```
/// M.S
/// .A.
/// M.S
/// ```
Future<int> calculate(File file) async {
  final lines = await loadData(file);
  return _calculate(lines);
}

int _calculate(List<String> lines) {
  var result = 0;
  for (var r = 0; r < lines.length; r++) {
    final line = lines[r];
    for (var c = 0; c < line.length; c++) {
      result += _isPositionCrossMas(lines, r, c) ? 1 : 0;
    }
  }

  return result;
}

bool _isPositionCrossMas(List<String> lines, int row, int col) {
  final line = lines[row];
  final char = line[col];

  // Only check spaces that begin with an 'X'.
  if (char != 'A') {
    return false;
  }

  // Any 'A' at the edge cannot be in the shape of an X.
  if (row == 0 ||
      row == lines.length - 1 ||
      col == 0 ||
      col == lines[0].length - 1) {
    return false;
  }

  // Extract the two diagonal strings.
  final forward = lines[row - 1][col - 1] + char + lines[row + 1][col + 1];
  final back = lines[row + 1][col - 1] + char + lines[row - 1][col + 1];

  return _isMas(forward) && _isMas(back);
}

bool _isMas(final String str) {
  return str == 'MAS' || str == 'SAM';
}
