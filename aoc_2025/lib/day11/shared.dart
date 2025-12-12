import 'dart:io';

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
