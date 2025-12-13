import 'dart:io';

import 'package:collection/collection.dart';

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

/// Recursive function to determine the number of paths from the given node
/// to the 'out' node, only allowing a single visit to any given node, and
/// requiring the given nodes to be in the path at some point.
int numPathsToEnd({
  required String node,
  required Map<String, Set<String>> graph,
  required Set<String> requiredNodesInPath,
  required Map<String, int> cachedValues,
}) {
  if (node == 'out') {
    // Path is only valid if we visited the required nodes.
    if (requiredNodesInPath.isEmpty) {
      return 1;
    }
    return 0;
  }

  // Check to see if we've already processed the node at a similar
  // point in its path (still needing the specified nodes).
  // Use a string-only cache key, which performs much better
  // than a record.
  final cacheKey = '$node${requiredNodesInPath.join('')}';
  final cachedValue = cachedValues[cacheKey];
  if (cachedValue != null) {
    return cachedValue;
  }

  int numPaths = 0;
  final nextNodes = graph[node] ?? {};
  for (final next in nextNodes) {
    numPaths += numPathsToEnd(
      node: next,
      graph: graph,
      // If the next node is one of the required nodes, remove it from the
      // required node set in this branch.
      requiredNodesInPath: requiredNodesInPath
          .whereNot((s) => s == next)
          .toSet(),
      cachedValues: cachedValues,
    );
  }

  cachedValues[cacheKey] = numPaths;
  return numPaths;
}
