import 'dart:io';

import 'shared.dart';

/// Given a disk map like:
/// ```
/// 2333133121414131402
/// ```
///
/// Each element is an integer size (0-9), alternating between
/// occupied space and free space (starting with occupied). Each
/// occupied space has an integer id, starting at zero. Expanded,
/// the example above maps to the following:
/// ```
/// 00...111...2...333.44.5555.6666.777.888899
/// ```
///
/// Where the integers are file ids, and `.` represents empty space.
/// NOTE: ids can be greater than 9, but the string format above is
/// not possible for more than 10 files.
///
/// To solve the problem, starting from the right, defrag the disk by
/// moving single blocks from files into free spaces on the left.
/// For a shorter example, this would look like:
/// ```
/// 0..111....22222
/// 02.111....2222.
/// 022111....222..
/// 0221112...22...
/// 02211122..2....
/// 022111222......
/// ```
///
/// After performing the drag, return a checksum by adding up the
/// results of multiplying each memory location's index by the file id
/// stored there (e.g 0*0 + 1*2 + 2*2 ...). Free spaces are skipped.
Future<int> calculate(File file) async {
  final memory = await loadMemory(file);

  int nextFree = 0;
  while (memory[nextFree].id != null) {
    nextFree++;
  }

  int nextToMove = memory.length - 1;
  while (memory[nextToMove].id == null) {
    nextToMove--;
  }

  while (nextToMove > nextFree) {
    memory[nextFree].id = memory[nextToMove].id;
    memory[nextToMove].id = null;
    nextFree++;
    nextToMove--;

    while (nextFree < memory.length && memory[nextFree].id != null) {
      nextFree++;
    }
    while (nextToMove >= 0 && memory[nextToMove].id == null) {
      nextToMove--;
    }
  }

  int checksum = 0;
  for (int i = 0; i < memory.length; i++) {
    final memoryVal = memory[i].id ?? 0;
    checksum += memoryVal * i;
  }
  return checksum;
}
