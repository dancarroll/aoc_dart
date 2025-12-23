import 'dart:io';

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
  return machines
      .map(
        (machine) =>
            machine.buttonCombinationsToReachTargetIndicators().first.length,
      )
      .sum;
}
