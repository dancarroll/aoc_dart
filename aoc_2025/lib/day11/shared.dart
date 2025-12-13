import 'dart:io';

import 'package:collection/collection.dart';

Future<Map<String, Set<String>>> loadData(File file) async {
  final lines = await file.readAsLines();

  final graph = <String, Set<String>>{};
  for (final line in lines) {
    final parts = line.split(' ');
    final node = parts[0].substring(0, parts[0].length - 1);

    graph[node] = parts.skip(1).toSet();
  }

  return graph;
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
