import 'dart:io';

import 'package:collection/collection.dart';

/// Represents a present type.
final class Present {
  /// Total number of blocks this present takes up in 2d grid.
  final int size;

  /// Layout of present. True indicates the present takes up that block, false
  /// indicates the space is empty.
  final List<List<bool>> layout;

  Present(this.layout) : size = layout.map((l) => l.where((b) => b).length).sum;
}

/// Repesents a tree region in the Christmas tree farm.
final class TreeRegion {
  /// Width of the region.
  final int width;

  /// Height of the region.
  final int height;

  /// Presents required. Each index of this list corresponds to a present type
  /// at the same index. The numeric value indicates the number of that type of
  /// present that is required.
  final List<int> presentsRequired;

  TreeRegion(this.width, this.height, this.presentsRequired);
}

/// Represents the Christmas Tree Farm from the problem.
final class ChristmasTreeFarm {
  /// List of present types available.
  final List<Present> presents;

  /// List of tree regions on the farm that require presents.
  final List<TreeRegion> treeRegions;

  ChristmasTreeFarm(this.presents, this.treeRegions);
}

final sizeRegex = RegExp(r'(?<w>\d+)x(?<h>\d+)');

Future<ChristmasTreeFarm> loadData(File file) async {
  final lines = await file.readAsLines();

  List<Present> presents = [];
  List<TreeRegion> treeRegions = [];

  List<List<bool>> presentLayout = [];
  for (final line in lines) {
    if (line.contains('x')) {
      // Parsing a tree layout
      final parts = line.split(' ');
      final match = sizeRegex.firstMatch(parts[0])!;

      treeRegions.add(
        TreeRegion(
          int.parse(match.namedGroup('w')!),
          int.parse(match.namedGroup('h')!),
          parts.skip(1).map(int.parse).toList(),
        ),
      );
    } else if (line.isEmpty) {
      // End of previous present
      presents.add(Present(presentLayout));
    } else if (line.contains(':')) {
      // Start of new present
      presentLayout = [];
    } else {
      // Continuing to process lines related to the current present type.
      presentLayout.add(line.split('').map((c) => c == '#').toList());
    }
  }

  return ChristmasTreeFarm(presents, treeRegions);
}
