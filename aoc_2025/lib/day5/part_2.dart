import 'dart:io';

import 'package:collection/collection.dart';

import 'shared.dart';

/// Following from part 1, the list of ingredients doesn't matter.
/// Given all of the fresh ingredient ranges, compture the total number
/// of fresh ingredients by combining all of the overlapping ranges,
/// and determining how many unique fresh ingredient ids exist.
Future<int> calculate(File file) async {
  final kitchen = await loadData(file);
  var ranges = kitchen.freshIngredientRanges;

  // Iterate over the list of ranges, running a single pass combine
  // function until not more combinations can be made.
  int numRangesCombined = 1;
  while (numRangesCombined > 0) {
    final newRanges = singlePassCombineRanges(ranges);
    numRangesCombined = ranges.length - newRanges.length;
    ranges = newRanges;
  }

  // Return the sum of all of the range lengths.
  return ranges.map((range) => range.size).sum;
}

/// Takes a single pass through the list of ranges, and combines each
/// range with the first intersecting range it finds.
List<Range> singlePassCombineRanges(List<Range> ranges) {
  // Keep track of all of the unique isolated ranges during this pass.
  List<Range> isolatedRanges = [];

  for (final rangeToProcess in ranges) {
    bool combinedWithExistingRange = false;
    for (final rangeToCompare in isolatedRanges) {
      // Check to see if these two ranges intersect. If so, just store the
      // combined range.
      final union = rangeToCompare.union(rangeToProcess);
      if (union != null) {
        isolatedRanges.remove(rangeToCompare);
        isolatedRanges.add(union);
        combinedWithExistingRange = true;
        break;
      }
    }

    // If it didn't intersect, just add it to the isolated range list.
    if (!combinedWithExistingRange) {
      isolatedRanges.add(rangeToProcess);
    }
  }

  return isolatedRanges;
}
