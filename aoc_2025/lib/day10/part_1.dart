import 'dart:collection';
import 'dart:io';

import 'package:aoc_shared/shared.dart';
import 'package:collection/collection.dart';

import 'shared.dart';

/// --- Day 10: Factory ---
///
/// You are given a list of machines. Each machine has an indicator light
/// panel, with a target sequence of lights. Each machine also has a set of
/// buttons, where each button toggles a set of lights in the indicator panel.
/// Determine the fewest number of button presses necessary to match the
/// target indicator lights.
///
/// Find the smallest value for each machine and return the sum of those values.
Future<int> calculate(File file) async {
  final machines = await loadData(file);
  return machines.map(_fewestButtonPresses).sum;
}

final listEquality = ListEquality();

/// BFS algorithm to find the fewest button presses necessary to match the
/// target indicators for the given machine.
int _fewestButtonPresses(Machine machine) {
  // BFS queue stores records of each state: the indicator state, and the
  // buttons pressed to get to that state.
  Queue<({List<bool> indicators, List<int> pressedButtons})> queue = Queue();
  queue.add((
    indicators: List.filled(machine.targetIndicators.length, false),
    pressedButtons: <int>[],
  ));

  while (queue.isNotEmpty) {
    final current = queue.removeFirst();

    // If we reach the target state, return immediately. Due to the
    // breadth-first processing, this would be guaranteed to be the fewest
    // number of button presses.
    if (listEquality.equals(current.indicators, machine.targetIndicators)) {
      return current.pressedButtons.length;
    }

    for (int i = 0; i < machine.buttons.length; i++) {
      // We only allow each button to be pressed once in any chain. There
      // is no point to allow the same button to be pressed multiple times,
      // as it would just undo the initial press.
      if (current.pressedButtons.contains(i)) {
        continue;
      }

      // Set the next state for when this button is pressed.
      final button = machine.buttons[i];
      final newIndicators = [...current.indicators];
      final newPressedButtons = [...current.pressedButtons, i];

      // Apply all the changes made by pressing the button.
      for (final indicatorChange in button) {
        newIndicators[indicatorChange] = !newIndicators[indicatorChange];
      }

      // Add this next step to the back of the queue.
      queue.add((indicators: newIndicators, pressedButtons: newPressedButtons));
    }
  }

  return maxInt;
}
