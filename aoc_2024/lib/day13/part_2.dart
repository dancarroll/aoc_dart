import 'dart:io';

import 'shared.dart';

/// Value to add to the x and y coordinates for all prizes.
const prizeHop = 10_000_000_000_000;

/// Continuing from part 1, except the (x,y) coordinates for the prize each
/// have 10,000,000,000,000 added to them.
Future<int> calculate(File file) async {
  final machines = await loadData(file, prizeHop: prizeHop);

  // We can not iterate like in Part 1, due to the extremely large values
  // involved. Instead, we can solve for the value of "A clicks" and "B clicks"
  // using simple algebra.
  //
  // We know that the values of A and B need to satisfy the following equations:
  //
  //   A * a_x + B * b_x = P_x
  //   A * a_y + B * b_y = P_y
  //
  // All values except A and B are known. We can isolate one of those variables,
  // to redefine an equation:
  //
  //       P_x - A * a_x
  //   B = -------------
  //            b_x
  //
  // Then, insert the B equation into the other equation, and isolate X:
  //
  //              P_x * b_y
  //        P_y - ---------
  //                 b_x
  //   A = -----------------
  //              a_x * b_y
  //        a_y - ---------
  //                 b_x
  //
  // We can simplify the equation further by multiplying the right side by
  // (b_x)/(b_x) (which equals 1).
  //
  //       P_y * b_x - P_x * b_y
  //   A = ---------------------
  //       a_y * b_x - a_x * b_y
  //
  // From that, we can solve for A. After we have A, we can construct a simple
  // equation to solve for B:
  //
  //       P_x - A * a_x
  //   B = -------------
  //            b_x

  int totalCost = 0;
  for (final machine in machines) {
    final px = machine.prize.x;
    final py = machine.prize.y;
    final ax = machine.buttonA.x;
    final ay = machine.buttonA.y;
    final bx = machine.buttonB.x;
    final by = machine.buttonB.y;

    final a = (py * bx - px * by) / (ay * bx - ax * by);
    final b = (px - a * ax) / bx;

    final aInt = toWholeNumber(a);
    final bInt = toWholeNumber(b);

    // A and B are only valid if they are both whole numbers, since they
    // need to represent an exact number of clicks for each button.
    if (aInt != null && bInt != null) {
      totalCost += 3 * aInt + bInt;
    }
  }

  return totalCost;
}

/// Attempts to cast the given number into a whole number. If it is not a
/// whole number within a small error bound, returns null.
int? toWholeNumber(double num) =>
    (num >= 0.0 && (num - num.round()).abs() < 0.001) ? num.round() : null;
