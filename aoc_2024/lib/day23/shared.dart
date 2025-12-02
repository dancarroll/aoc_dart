import 'dart:io';

/// Load a map of computer conections from a file.
Future<Map<String, Set<String>>> loadData(File file) async {
  final lines = await file.readAsLines();

  final network = <String, Set<String>>{};
  for (final line in lines) {
    final computers = line.split('-');
    assert(computers.length == 2, 'Only two names expected');

    network.update(
      computers[0],
      (l) => l..add(computers[1]),
      ifAbsent: () => {computers[1]},
    );
    network.update(
      computers[1],
      (l) => l..add(computers[0]),
      ifAbsent: () => {computers[0]},
    );
  }

  return network;
}
