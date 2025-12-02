import 'dart:io';

/// Represents a wire in a circuit.
abstract class Wire {
  bool calculate(Map<String, Wire> input);
}

/// Represents a input wire with a fixed value.
final class FixedWire extends Wire {
  final bool val;

  FixedWire(this.val);

  @override
  bool calculate(Map<String, Wire> input) => val;

  @override
  String toString() => val ? '1' : '0';
}

/// Represents the binary gate options.
enum Gate {
  and,
  or,
  xor;

  factory Gate.fromString(String str) => switch (str) {
    'AND' => and,
    'OR' => or,
    'XOR' => xor,
    _ => throw Exception('Unsupported operator $str'),
  };
}

/// Represents two input wires connected to a gate with one output wire.
final class GateWire extends Wire {
  final Gate gate;
  final (String, String) pair;

  GateWire(this.gate, this.pair);

  @override
  bool calculate(Map<String, Wire> input) {
    final input1 = input[pair.$1]!.calculate(input);
    final input2 = input[pair.$2]!.calculate(input);

    return switch (gate) {
      Gate.and => input1 && input2,
      Gate.or => input1 || input2,
      Gate.xor => input1 ^ input2,
    };
  }
}

/// Loads wire data from a file.
Future<Map<String, Wire>> loadData(File file) async {
  final lines = await file.readAsLines();

  Map<String, Wire> wires = {};

  RegExp regex = RegExp(
    r'^(?<input1>[a-z0-9]+) (?<op>AND|OR|XOR) (?<input2>[a-z0-9]+) -> '
    r'(?<output>[a-z0-9]+)$',
  );

  bool parsingGates = false;
  for (int i = 0; i < lines.length; i++) {
    final line = lines[i];
    if (line.isEmpty) {
      parsingGates = true;
    } else if (parsingGates) {
      final match = regex.firstMatch(line);
      if (match == null) throw Exception();
      wires[match.namedGroup('output')!] = GateWire(
        Gate.fromString(match.namedGroup('op')!),
        (match.namedGroup('input1')!, match.namedGroup('input2')!),
      );
    } else {
      final parts = line.split(': ');
      wires[parts[0]] = FixedWire(parts[1] == '1');
    }
  }

  return wires;
}
