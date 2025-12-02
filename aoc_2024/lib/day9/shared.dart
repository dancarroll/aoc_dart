import 'dart:io';

/// Represents a block of space on the disk.
final class BlockReference {
  /// Size of this block.
  int size;

  /// Id of the file stored here. If this block is empty, the
  /// id is [null].
  int? id;

  BlockReference({required this.size, required this.id});

  /// Returns true if this block is free.
  bool get isFree => id == null;
}

/// Represents a single block of memory.
final class MemoryLocation {
  /// If this block is in used, the id of the file consuming this
  /// memory location (files may be spread across many locations).
  int? id;

  MemoryLocation(this.id);
}

/// Loads a disk map file as a short-form list of block references.
Future<List<BlockReference>> loadBlocks(File file) async {
  final line = await file.readAsString();

  List<BlockReference> references = [];
  int id = 0;
  bool isFile = true;
  for (int i = 0; i < line.length; i++) {
    references.add(
      BlockReference(size: int.parse(line[i]), id: isFile ? id : null),
    );
    if (isFile) id++;
    isFile = !isFile;
  }

  return references;
}

/// Loads a disk map file as an exploded list of memory locations.
Future<List<MemoryLocation>> loadMemory(File file) async {
  final line = await file.readAsString();

  List<MemoryLocation> memory = [];
  int id = 0;
  bool isFile = true;
  for (int i = 0; i < line.length; i++) {
    final count = int.parse(line[i]);
    for (int j = 0; j < count; j++) {
      memory.add(MemoryLocation(isFile ? id : null));
    }
    if (isFile) id++;
    isFile = !isFile;
  }

  return memory;
}
