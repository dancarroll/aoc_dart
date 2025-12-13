import 'dart:io';

import 'package:collection/collection.dart';

import 'shared.dart';

/// --- Day 12: Christmas Tree Farm ---
///
/// Farm has trees that need presents under them. We have a list of present
/// types with a certain shape, and a number of tree regions where presents
/// should be placed. Each region has a certain 2d size, and lists out the
/// number of each type of present that should be placed under the tree.
///
/// Return the number of regions where the presents can be laid out in the
/// size given.
///
/// Note: this was a bit of a trick question. It's possible the solve the
/// input given with very basic heuristics, rather than needing very
/// complicated object packing logic.
Future<int> calculate(File file) async {
  final farm = await loadData(file);

  int numAbleToFit = 0;
  for (final region in farm.treeRegions) {
    final requiredPresentBlocks = region.presentsRequired.foldIndexed(
      0,
      (index, prev, numPresents) =>
          prev + farm.presents[index].size * numPresents,
    );

    final blocksUnderTree = region.width * region.height;

    if (requiredPresentBlocks <= blocksUnderTree) {
      numAbleToFit++;
    }
  }

  return numAbleToFit;
}
