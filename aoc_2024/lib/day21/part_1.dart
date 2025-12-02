import 'dart:io';

import 'shared.dart';
import 'sequences.dart';

/// --- Day 21: Keypad Conundrum ---
///
/// Need to instruct a robot to enter a code on a keypad, by telling it how to
/// move an arm (up, down, left, right) to certain buttons, then when to press
/// the button it is pointing at. The robot can never be pointing at an empty
/// space (there is one blank space on the keypad).
///
/// However, we are not controlling the robot directly. Instead, there are two
/// robots in sequence, each of which has a keypad in front of it. Rather than
/// numbers, these keypads have directions, which instruct the next robot in
/// line how to move.
///
/// At the front is you, with a keypad to instruct to first robot how to move.
/// You -> Robot 1 (directional) -> Robot 2 (directional) -> Robot 3 (numeric).
///
/// For each code in the input file, determine the minimum number of button
/// presses you need to do to get the final robot to enter the code. For each
/// code, multiply the numeric portion of the code against the minimum button
/// presses, which gives the complexity. Return the sum of all of the complexity
/// values.
Future<int> calculate(File file) async {
  final data = await loadData(file);
  return totalComplexityForCodes(data, numDirectionalKeypads: 2);
}
