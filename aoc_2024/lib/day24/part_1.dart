import 'dart:io';

import 'package:collection/collection.dart';

import 'shared.dart';

/// --- Day 24: Crossed Wires ---
///
/// Given the input of initial wire states, and a sequence of gates
/// connected to the those wires, compute the final state for all
/// wires beginning with 'z'. Take all of the values of the z gates,
/// and return the integer representation.
Future<int> calculate(File file) async {
  final wires = await loadData(file);

  final zWires = wires.entries
      .where((e) => e.key.startsWith('z'))
      .sortedBy((e) => e.key)
      .reversed
      .map((e) => e.value.calculate(wires) ? '1' : '0')
      .join('');

  return int.parse(zWires, radix: 2);
}
