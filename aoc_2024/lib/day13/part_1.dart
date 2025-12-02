import 'dart:io';

import 'package:aoc_shared/shared.dart';

import 'shared.dart';

Future<int> calculate(File file) async {
  final machines = await loadData(file);

  int totalCost = 0;
  for (final machine in machines) {
    final cost = processMachine(machine);
    if (cost != null) {
      totalCost += cost;
    }
  }

  return totalCost;
}

typedef Clicks = (int, int);

int? processMachine(Machine machine) {
  int? lowestCost;

  final clickPairs = orderedPairs(List<int>.generate(101, (i) => i));
  for (final pair in clickPairs) {
    if (doClicksPositionOverPrize(pair.$1, pair.$2, machine)) {
      final cost = pair.$1 * 3 + pair.$2;
      if (lowestCost == null || cost < lowestCost) {
        lowestCost = cost;
      }
    }
  }

  return lowestCost;
}

bool doClicksPositionOverPrize(int a, int b, Machine machine) {
  final x = a * machine.buttonA.x + b * machine.buttonB.x;
  final y = a * machine.buttonA.y + b * machine.buttonB.y;
  return x == machine.prize.x && y == machine.prize.y;
}
