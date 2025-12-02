import 'dart:math';

import 'package:aoc_shared/shared.dart';
import 'package:collection/collection.dart' as collection;

import 'shared.dart';

final directionKeypad = DirectionalKeypad.standard();

/// Determine the shortest sequence of directions in a sequence of
/// [numDirectionalKeypads] directional keypads.
int shortestSequenceForNumpadEntry(
  Set<DirectionList> options,
  int numDirectionalKeypads,
) {
  int lowestCost = maxInt;
  for (final list in options) {
    final cost = costForDirectionList(list, numDirectionalKeypads);
    if (cost < lowestCost) {
      lowestCost = cost;
    }
  }
  return lowestCost;
}

/// Calculate the cost to enter the list of [directions] in a sequence of
/// [numDirectionalKeypads] directional keypads.
int costForDirectionList(DirectionList directions, int numDirectionalKeypads) {
  int cost = 0;
  for (final group in directions.splitIntoActivateGroups()) {
    var starting = DirectionalButton.activate;
    for (final direction in group) {
      cost += costForDirectionInPhase(
        direction,
        starting,
        1,
        numDirectionalKeypads,
      );
      starting = direction;
    }
  }

  return cost;
}

/// Key for the lowest cost map. Costs are defined by the starting->target
/// button path, and the directional keypad iteration.
typedef IterationRecord = ({
  DirectionalButton targetButton,
  DirectionalButton startingButton,
  int iteration,
});

/// Map of the lowest cost seen for a given iteration record.
Map<IterationRecord, int> costPerIteration = {};

/// Calculate the cost to reach [target] from [start] in the [phase] keyboard
/// in a sequence of [numDirectionalKeypads] directional keypads.
int costForDirectionInPhase(
  DirectionalButton target,
  DirectionalButton start,
  int phase,
  int numDirectionalKeypads,
) {
  final key = (targetButton: target, startingButton: start, iteration: phase);
  if (costPerIteration.containsKey(key)) {
    return costPerIteration[key]!;
  }

  if (phase >= numDirectionalKeypads) {
    final count = directionKeypad
        .stepCombinationsTo(directionKeypad.layout.inverse[start]!, target)
        .map((l) => l.length)
        .min;
    costPerIteration[key] = count;
    return count;
  }

  int lowestCost = maxInt;
  for (final combination in directionKeypad.stepCombinationsTo(
    directionKeypad.layout.inverse[start]!,
    target,
  )) {
    int cost = 0;
    var lastStep = DirectionalButton.activate;
    for (final step in combination) {
      cost += costForDirectionInPhase(
        step,
        lastStep,
        phase + 1,
        numDirectionalKeypads,
      );
      lastStep = step;
    }

    if (cost < lowestCost) {
      lowestCost = cost;
    }
  }

  costPerIteration[key] = lowestCost;
  return lowestCost;
}

/// Computer the shortest sequence to enter the given [code], when there
/// are [numDirectionalKeypads] directional keypads controlled by robots
/// in between a human and the numpad-controlling robot.
int shortestSequence(String code, int numDirectionalKeypads) {
  final numericKeypad = NumericKeypad.standard();

  Set<DirectionList> numericSteps = {};

  // Find all combinations for how to move in the numeric keypad.
  Point<int> numericKeypadPointer = numericKeypad.buttonLocation('A');
  for (final char in code.split('')) {
    Set<DirectionList> newList = {};
    final numericStepsForChar = numericKeypad.stepCombinationsTo(
      numericKeypadPointer,
      char,
    );
    if (numericSteps.isEmpty) {
      newList.addAll(numericStepsForChar);
    } else {
      for (final previousDirections in numericSteps) {
        for (final newDirections in numericStepsForChar) {
          newList.add(DirectionList([...previousDirections, ...newDirections]));
        }
      }
    }

    numericKeypadPointer = numericKeypad.buttonLocation(char);
    numericSteps = newList;
  }

  // Then execute the logic to determine the shortest path for all of the
  // directional keypad entries.
  return shortestSequenceForNumpadEntry(numericSteps, numDirectionalKeypads);
}

/// Returns the total complexity for all codes, given a sequence of
/// [numDirectionalKeypads] direction keypads controlled by robots, controlling
/// one robot at a numeric keypad.
Future<int> totalComplexityForCodes(
  List<String> codes, {
  required int numDirectionalKeypads,
}) async {
  costPerIteration.clear();

  return codes
      .map((code) => (code, shortestSequence(code, numDirectionalKeypads)))
      .map((r) => r.$2 * int.parse(r.$1.substring(0, 3)))
      .sum;
}
