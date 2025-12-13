import 'dart:io';

import 'shared.dart';

/// Following from Part 1, we now need to start at the `svr` node
/// and calculate all of the paths to the `out` node that also travel
/// through the `dac` and `fft` nodes.
Future<int> calculate(File file) async {
  final graph = await loadData(file);

  return numPathsToEnd(
    node: 'svr',
    graph: graph,
    requiredNodesInPath: {'dac', 'fft'},
    cachedValues: {},
  );
}
