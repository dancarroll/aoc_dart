import 'dart:collection';
import 'dart:io';

import 'package:collection/collection.dart';

final listEquality = ListEquality();

/// Represents a machine from the problem.
final class Machine {
  /// The target indicators we need to match (true means indicator
  /// light is on).
  final List<bool> targetIndicators;

  /// List of buttons. Each button has a list of indicator light
  /// indices it changes).
  final List<List<int>> buttons;

  /// List of target joltages.
  final List<int> joltages;

  Machine(this.targetIndicators, this.buttons, this.joltages);

  /// Creates a machine based on one line from the input file.
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

  /// Calculates the joltage remaining after pressing the buttons
  /// at the specified indices.
  List<int> reduceJoltageTargetFromPresses(
    List<int> joltages,
    Iterable<int> buttonCombination,
  ) {
    final joltageRemaining = List<int>.from(joltages);
    for (final buttonIndex in buttonCombination) {
      for (final joltageIndex in buttons[buttonIndex]) {
        joltageRemaining[joltageIndex]--;
      }
    }

    return joltageRemaining;
  }

  /// Returns the all the button combinations that will result in
  /// this machines targeted indicator light configuration.
  Iterable<Set<int>> buttonCombinationsToReachTargetIndicators() {
    return buttonCombinationsToReachIndicators(targetIndicators);
  }

  /// BFS algorithm to find the set of button presses to match a given set of
  /// indicators for this machine.
  Iterable<Set<int>> buttonCombinationsToReachIndicators(
    List<bool> targetIndicators,
  ) sync* {
    /// Build an efficient int mask to represent the targeted indicators.
    int targetMask = 0;
    for (int i = 0; i < targetIndicators.length; i++) {
      if (targetIndicators[i]) targetMask |= (1 << i);
    }

    // BFS queue stores records of each state: the indicator state, and the
    // buttons pressed to get to that state.
    Queue<({int indicators, int pressedButtons})> queue = Queue();
    queue.add((indicators: 0, pressedButtons: 0));

    Set<int> seenCombinations = {};

    while (queue.isNotEmpty) {
      final current = queue.removeFirst();

      // Helper to convert bitmask back to Set<int>
      Set<int> maskToSet(int mask) {
        int curr = mask;
        final set = <int>{};
        int index = 0;
        while (curr > 0) {
          if ((curr & 1) == 1) set.add(index);
          curr >>= 1;
          index++;
        }
        return set;
      }

      if (current.indicators == targetMask) {
        // When we reach the targeted indicators, need to convert the
        // bitmask back to a set.
        yield maskToSet(current.pressedButtons);
      }

      for (int i = 0; i < buttons.length; i++) {
        // Check if button 'i' is already in the pressed mask. If so,
        // don't process it again, since it would just undo the
        // previous press.
        if ((current.pressedButtons & (1 << i)) != 0) {
          continue;
        }

        final nextPressedButtons = current.pressedButtons | (1 << i);

        // If this combination has already been seen, skip it.
        if (seenCombinations.contains(nextPressedButtons)) {
          continue;
        }
        seenCombinations.add(nextPressedButtons);

        // Calculate the next bitmask by XORing each indicator change.
        int nextIndicators = current.indicators;
        for (final affectedIndex in buttons[i]) {
          nextIndicators ^= (1 << affectedIndex);
        }

        queue.add((
          indicators: nextIndicators,
          pressedButtons: nextPressedButtons,
        ));
      }
    }
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
