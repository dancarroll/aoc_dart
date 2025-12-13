import 'dart:io';

import 'shared.dart';

/// --- Day 11: Reactor ---
///
/// Given a directed graph, determine the number of paths between
/// node 'you' and node 'out'.
Future<int> calculate(File file) async {
  final graph = await loadData(file);

  return numPathsToEnd(
    node: 'you',
    graph: graph,
    requiredNodesInPath: {},
    cachedValues: {},
  );
}
