import 'dart:io';

// final class Button {
//   final List<int> activations;

//   Button(this.activations);
// }

final class Machine {
  //final List<bool> indicators;
  final List<bool> targetIndicators;

  final List<List<int>> buttons;

  final List<int> joltages;

  Machine(this.targetIndicators, this.buttons, this.joltages);
  //: indicators = List.filled(targetIndicators.length, false);

  factory Machine.fromStrings(
    String indicatorsStr,
    Iterable<String> buttonStrs,
    String joltagesStr,
  ) {
    final targetIndicators = indicatorsStr
        .substring(1, indicatorsStr.length - 1)
        .split('')
        .map((c) => c == '#')
        .toList();

    final buttons = buttonStrs
        .map(
          (buttonStr) => buttonStr
              .substring(1, buttonStr.length - 1)
              .split(',')
              .map(int.parse)
              .toList(),
        )
        .toList();

    final joltages = joltagesStr
        .substring(1, joltagesStr.length - 1)
        .split(',')
        .map(int.parse)
        .toList();

    return Machine(targetIndicators, buttons, joltages);
  }
}

Future<List<Machine>> loadData(File file) async {
  final lines = await file.readAsLines();

  final machines = <Machine>[];
  for (final line in lines) {
    final parts = line.split(' ');
    machines.add(
      Machine.fromStrings(
        parts.first,
        parts.skip(1).take(parts.length - 2),
        parts.last,
      ),
    );
  }

  return machines;
}
