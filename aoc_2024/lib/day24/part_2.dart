import 'dart:io';

import 'package:collection/collection.dart';

import 'shared.dart';

/// Continuing from Part 1 -- we now know that there are four pairs
/// of wires swapped, and that the circuit should be perform addition
/// of 45-bit numbers (e.g. x00 is the first bit of the x input, and
/// the circuit should calculate x+y, with the result stored in the
/// x00-x45 outputs).
///
/// Identify the four pairs of wires to be swapped (eight wires), and
/// return those values comma-separated and sorted.
Future<String> calculate(File file) async {
  // If this is the sample data, just return immediately. The sample is
  // a completely different problem (simple AND circuit, not an adder).
  if (file.path.contains('sample_data')) {
    return '<unsupported>';
  }

  final wires = await loadData(file);

  // The actual inputs we received don't really matter. To make identifying
  // swapped wires easier, set all of one of the inputs to 1 and the other
  // to zero. We will be looking for an output of all zeroes.
  for (final wire in wires.keys.where((k) => k.startsWith('x')).toList()) {
    wires[wire] = FixedWire(false);
    wires[wire.replaceRange(0, 1, 'y')] = FixedWire(true);
  }

  List<(String, String)> swaps = [];
  var incorrectOutput = _getIncorrectOutputWires(wires);
  while (incorrectOutput.isNotEmpty) {
    final targetName = incorrectOutput.first;
    final targetWire = wires[targetName]!;
    String inputName = targetName.replaceRange(0, 1, 'x');

    bool isXorWithInput(Wire wire, String name) =>
        wire is GateWire &&
        wire.gate == Gate.xor &&
        (wire.pair.$1 == name || wire.pair.$2 == name);

    // Output wires need to be directly connected to an XOR.
    if (targetWire is GateWire && targetWire.gate != Gate.xor) {
      // If it's not an XOR, let's find where the XOR is. Since this
      // is full ripple adder circuit, we expect a chain of two XORs.
      // x XOR y feeds into another XOR, which feeds the output.
      final firstXor = wires.entries
          .where((e) => isXorWithInput(e.value, inputName))
          .first
          .key;
      final secondXor = wires.entries
          .where((e) => isXorWithInput(e.value, firstXor))
          .first
          .key;

      // Perform the swap.
      _swap(wires, targetName, secondXor);
      swaps.add((targetName, secondXor));
    } else if (targetWire is GateWire) {
      // If it's already an XOR, we need to take a different approach.
      // Let's backtrack one more step -- the output XOR gate should
      // be fed by and XOR and an OR gate (the latter is the carry
      // from the previous bit).
      final gateInput1 = wires[targetWire.pair.$1] as GateWire;
      final gateInput2 = wires[targetWire.pair.$2] as GateWire;

      String badGateName = '';
      GateWire? badGate;
      // If we find an AND gate, we know it is bad.
      if (gateInput1.gate == Gate.and) {
        badGateName = targetWire.pair.$1;
        badGate = gateInput1;
      } else if (gateInput2.gate == Gate.and) {
        badGateName = targetWire.pair.$2;
        badGate = gateInput2;
      }

      if (badGate == null) throw Exception('Did not find bad gate');

      // We've got one of the bad gates now. This position should actually
      // have an XOR of the corresponding x and y inputs, so find that.
      final inputXor = wires.entries
          .where((e) => isXorWithInput(e.value, inputName))
          .first
          .key;

      // We've got the wires, not make the swap.
      // Perform the swap.
      _swap(wires, badGateName, inputXor);
      swaps.add((badGateName, inputXor));
    } else {
      throw Exception('Unable to handle this circuit problem');
    }

    // Update the incorrect wires before the next iteration.
    incorrectOutput = _getIncorrectOutputWires(wires);
  }

  return swaps.expand((e) => [e.$1, e.$2]).sorted().join(',');
}

/// Returns the binary representation of the wires starting with [char].
String _getBinaryFromWires(Map<String, Wire> wires, String char) {
  return wires.entries
      .where((e) => e.key.startsWith(char))
      .sortedBy((e) => e.key)
      .reversed
      .map((e) => e.value.calculate(wires) ? '1' : '0')
      .join('');
}

/// Gets the indices of the output wires that are incorrect.
List<int> _getIncorrectBits(Map<String, Wire> wires) {
  final x = _getNumberFromWires(wires, 'x');
  final y = _getNumberFromWires(wires, 'y');
  final expectedValue = x + y;

  final zBinary = _getBinaryFromWires(wires, 'z');
  final expectedBinary = expectedValue
      .toRadixString(2)
      .padLeft(zBinary.length, '0');

  final expectedBits = expectedBinary.split('');
  final actualBits = zBinary.split('');

  final incorrectIndices = <int>[];
  for (int i = 0; i < expectedBinary.length; i++) {
    if (expectedBits[expectedBits.length - i - 1] !=
        actualBits[actualBits.length - i - 1]) {
      incorrectIndices.add(i);
    }
  }

  return incorrectIndices;
}

/// Returns a list of output wire names that are incorrect, based on the
/// expected value.
List<String> _getIncorrectOutputWires(Map<String, Wire> wires) {
  return _getIncorrectBits(
    wires,
  ).map((i) => i.toString().padLeft(2, '0')).map((s) => 'z$s').toList();
}

/// Returns the integer number based on the binary values of the
/// wires started with the given [char].
int _getNumberFromWires(Map<String, Wire> wires, String char) {
  return int.parse(
    wires.entries
        .where((e) => e.key.startsWith(char))
        .sortedBy((e) => e.key)
        .reversed
        .map((e) => e.value.calculate(wires) ? '1' : '0')
        .join(''),
    radix: 2,
  );
}

/// Performs a wire swap.
void _swap(Map<String, Wire> wires, String one, String two) {
  final wire1 = wires[one]!;
  final wire2 = wires[two]!;
  wires[one] = wire2;
  wires[two] = wire1;
}
