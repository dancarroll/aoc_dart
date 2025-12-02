import 'dart:io';

import 'shared.dart';

/// Continuing from part 1, defrag the disk by don't split up files.
/// This means finding a large enough block of free space to move the
/// entire file.
///
/// Example:
/// ```
/// 00...111...2...333.44.5555.6666.777.888899
/// 0099.111...2...333.44.5555.6666.777.8888..
/// 0099.1117772...333.44.5555.6666.....8888..
/// 0099.111777244.333....5555.6666.....8888..
/// 00992111777.44.333....5555.6666.....8888..
/// ```
///
/// Calculate and return a checksum in the same manner as part 1.
Future<int> calculate(File file) async {
  final references = await loadBlocks(file);

  int nextFree = 1;
  int nextToMove = references.length - 1;

  while (nextToMove > nextFree && nextToMove >= 1) {
    while (references[nextToMove].isFree) {
      nextToMove--;
    }
    while (nextFree < nextToMove &&
        (references[nextToMove].size > references[nextFree].size ||
            !references[nextFree].isFree)) {
      nextFree++;
    }

    // If we've gotten into an illegal situation (moving memory to a
    // later position), then we can't move this block, so move to the
    // block on the left.
    if (nextFree >= nextToMove) {
      nextToMove--;
      nextFree = 0;
      continue;
    }

    final remainingFreeSpace =
        references[nextFree].size - references[nextToMove].size;
    references[nextFree].size = references[nextToMove].size;
    references[nextFree].id = references[nextToMove].id;
    references[nextToMove].id = null;

    if (remainingFreeSpace > 0) {
      references.insert(
        nextFree + 1,
        BlockReference(size: remainingFreeSpace, id: null),
      );
    } else {
      // If we added a new disk reference, then don't decrement here,
      // otherwise we would be skipping a block (due to the indices changing).
      nextToMove--;
    }

    nextFree = 0;
  }

  int blockChecksum = 0;
  int memoryIndex = 0;
  for (int i = 0; i < references.length; i++) {
    final ref = references[i];
    // For this block, we need to calculate:
    // [memoryIndex]*id + [memoryIndex+1]*id + ... [memoryIndex+size-1]*id
    //
    // Rather than iterating over each memory location in this block, we can
    // calculate the factor using the equation: (size/2) * (firstIndex + lastIndex).
    final factor =
        ((ref.size / 2) * (memoryIndex + (memoryIndex + ref.size - 1))).toInt();
    blockChecksum += factor * (ref.id ?? 0);
    memoryIndex += ref.size;
  }

  return blockChecksum;
}
