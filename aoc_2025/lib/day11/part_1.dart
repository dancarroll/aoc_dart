import 'dart:io';

import 'shared.dart';

/// --- Day 11: Reactor ---
///
/// Given a directed graph, determine the number of paths between
/// node 'you' and node 'out'.
Future<int> calculate(File file) async {
  final graph = await loadData(file);

  return numPathsToEnd('you', graph, {'you'});
}

/// Recursive function to determine the number of paths from the given node
/// to the 'out' node, only allowing a single visit to any given node.
int numPathsToEnd(
  String node,
  Map<String, Set<String>> graph,
  Set<String> visited,
) {
  if (node == 'out') {
    return 1;
  }

  int numPaths = 0;
  final nextNodes = graph[node] ?? {};
  for (final next in nextNodes) {
    if (visited.contains(next)) {
      continue;
    }

    numPaths += numPathsToEnd(next, graph, {...visited, next});
  }

  return numPaths;
}
