import 'dart:io';
import 'dart:math';

final class Machine {
  final Point<int> buttonA;
  final Point<int> buttonB;
  final Point<int> prize;

  Machine(this.buttonA, this.buttonB, this.prize);
}

/// Load data from a file. For the prize location, adds [prizeHop] to both
/// the x and y coordinates.
Future<List<Machine>> loadData(File file, {int prizeHop = 0}) async {
  final lines = await file.readAsLines();

  final buttonRegex = RegExp(r'Button \w: X\+(?<x>\d+), Y\+(?<y>\d+)');

  List<Machine> machines = [];
  int i = 0;
  while (i < lines.length) {
    buttonRegex.firstMatch(lines[i]);
    machines.add(
      Machine(
        parseButton(lines[i]),
        parseButton(lines[i + 1]),
        parsePrize(lines[i + 2], prizeHop: prizeHop),
      ),
    );

    // Skip four lines. The three lines that were just consumed, plus the
    // expected newline.
    i += 4;
  }

  return machines;
}

final buttonRegex = RegExp(r'Button \w: X\+(?<x>\d+), Y\+(?<y>\d+)');

Point<int> parseButton(String str) {
  final match = buttonRegex.firstMatch(str);
  return Point(
    convertToInt(match?.namedGroup('x')),
    convertToInt(match?.namedGroup('y')),
  );
}

final prizeRegex = RegExp(r'Prize: X=(?<x>\d+), Y=(?<y>\d+)');

Point<int> parsePrize(String str, {required int prizeHop}) {
  final match = prizeRegex.firstMatch(str);
  return Point(
    convertToInt(match?.namedGroup('x')) + prizeHop,
    convertToInt(match?.namedGroup('y')) + prizeHop,
  );
}

int convertToInt(String? str) {
  if (str == null) {
    throw Exception('Unexpected null string');
  }

  return int.parse(str);
}
