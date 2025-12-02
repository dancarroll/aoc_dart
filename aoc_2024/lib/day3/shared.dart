import 'dart:io';

/// Represents an instruction loaded from a file.
abstract class Instruction {}

/// A [Do] instructions means any following multiplication
/// should be executed.
final class Do extends Instruction {}

/// A [Dont] instructions means any following multiplication
/// should not be executed.
final class Dont extends Instruction {}

/// Represents a multiplication instruction.
final class Mult extends Instruction {
  final int first;
  final int second;

  Mult(String firstStr, String secondStr)
    : first = int.parse(firstStr),
      second = int.parse(secondStr);

  int get product => first * second;
}

/// Parses an instruction from a regular expression match.
Instruction _parseInstruction(RegExpMatch match) {
  if (match.namedGroup('mult') != null) {
    return Mult(
      match.namedGroup('first').toString(),
      match.namedGroup('second').toString(),
    );
  } else if (match.namedGroup('dont') != null) {
    return Dont();
  } else if (match.namedGroup('do') != null) {
    return Do();
  }

  throw Exception('unexpected group');
}

/// Parses a string into an ordered list of instructions.
List<Instruction> _parseLine(String line) {
  final regex = RegExp(
    // First group: match `mul(123, 456)`
    r'(?<mult>mul\((?<first>\d{1,3}),(?<second>\d{1,3})\))'
    // Second group: match `don't()`
    r"|(?<dont>don't\(\))"
    // Third group: match `do()`
    r'|(?<do>do\(\))',
  );

  return regex.allMatches(line).map(_parseInstruction).toList();
}

/// Loads a file and parses out all of the instructions in order.
Future<List<Instruction>> loadData(File file) async {
  final lines = await file.readAsLines();

  return lines.map(_parseLine).reduce((v, e) => v..addAll(e));
}
