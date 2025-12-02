import 'dart:io';

import 'package:aoc_shared/shared.dart';

import 'shared.dart';

/// --- Day 19: Linen Layout ---
///
/// Organizing towels into specified patterns.
///
/// Given a list of towels available (e.g. rw is a towel with a red strip and
/// a white stripe), and list of patterns, determine how many of the patterns
/// can be made with the given towel options.
Future<int> calculate(File file) async {
  final towels = await loadData(file);
  final options = towels.towels;

  // The simple, obvious approach to this problem is to just build a regular
  // expression to see if the string exactly matches a combination of one or
  // more towel options.
  //
  // However, given the number of towel options (447 in the real input), this
  // approach causes the Dart regex library to hang on the third pattern.
  //
  // Many of the patterns are made up of combinations of other patterns. We
  // can remove any pattern like that, which trims the combinations down to
  // ~74. The Dart regex library is able to handle that.

  // See if a pattern can be made from a pair of any other patterns
  for (final pair in pairs(options)) {
    // Make a pair in each order.
    final p1 = '${pair.$1}${pair.$2}';
    final p2 = '${pair.$2}${pair.$1}';

    // Also check for doubles of each pattern in the pair, for good measure.
    final p3 = '${pair.$1}${pair.$1}';
    final p4 = '${pair.$2}${pair.$2}';

    options.removeWhere((s) => s == p1 || s == p2 || s == p3 || s == p4);
  }

  final regex = RegExp('^(${options.join('|')})+\$');
  return towels.patterns.where(regex.hasMatch).length;
}
