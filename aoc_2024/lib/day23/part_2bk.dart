import 'dart:io';

import 'package:clique/clique.dart';
import 'package:collection/collection.dart';

import 'shared.dart';

/// Solution for Part 2 using the Bron–Kerbosch algorithm.
/// https://en.wikipedia.org/wiki/Bron%E2%80%93Kerbosch_algorithm
Future<String> calculate(File file) async {
  final network = await loadData(file);

  final maxClique = network.maximumClique();

  return maxClique.sorted().join(',');
}
