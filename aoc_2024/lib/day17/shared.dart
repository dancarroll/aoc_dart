import 'dart:io';
import 'dart:math' as math;

/// Represents an opcode for the 8-bit computer.
enum OpCode {
  /// Divide register A by 2^operand, store in A.
  adv,

  /// Register B XOR operand, store in B.
  bxl,

  /// Operand % 8, store in B.
  bst,

  /// Jump to index indicated by operand if register A > 0,
  /// otherwise do nothing.
  jnz,

  /// Register B XOR register C, store in B.
  bxc,

  /// Output operator % 8.
  out,

  /// Divide register A by 2^operand, store in B.
  bdv,

  /// Divide register A by 2^operand, store in C.
  cdv;

  /// Returns the enum value representing the opcode value.
  factory OpCode.fromNum(int num) => switch (num) {
    0 => adv,
    1 => bxl,
    2 => bst,
    3 => jnz,
    4 => bxc,
    5 => out,
    6 => bdv,
    7 => cdv,
    _ => throw Exception('Invalid opcode $num'),
  };
}

/// Represents a single instruction for the computer, which is an opcode
/// plus an operand.
final class Instruction {
  final OpCode opCode;
  final int operand;

  Instruction(this.opCode, this.operand);

  factory Instruction.fromInput(int opcodeNum, int operand) =>
      Instruction(OpCode.fromNum(opcodeNum), operand);
}

/// Represents the 8-bit computer with 3 storage registers.
final class Computer {
  int a;
  int b;
  int c;

  /// Index of the next instruction to execute.
  int _index = 0;

  /// List of instructions for the current program.
  final List<Instruction> instructions;

  /// The original string representation of the program instructions.
  final String serializedInstructions;

  Computer(
    this.a,
    this.b,
    this.c,
    this.instructions,
    this.serializedInstructions,
  );

  factory Computer.withOverrideA(Computer other, int a) => Computer(
    a,
    other.b,
    other.c,
    other.instructions,
    other.serializedInstructions,
  );

  /// Executes the program to completiong, and returns the result.
  /// If [allowJumps] is false, this execution will not allow the jump
  /// instruction.
  List<int> execute({bool allowJumps = true}) {
    List<int> result = [];

    while (_index < instructions.length) {
      final opCode = instructions[_index].opCode;
      final operand = _getOperandValue(opCode, instructions[_index].operand);

      switch (opCode) {
        case OpCode.adv:
          a = a ~/ math.pow(2, operand);
        case OpCode.bxl:
          b = b ^ operand;
        case OpCode.bst:
          b = operand % 8;
        case OpCode.jnz:
          if (a != 0 && allowJumps) {
            // Operand value represents the index. Since instructions represent
            // two indices (an opcode and operand), need to divide this by two.
            // Also subtracting one, as the index will be incremented at the end
            // of the loop.
            _index = (operand ~/ 2) - 1;
          }
        case OpCode.bxc:
          b = b ^ c;
        case OpCode.out:
          result.add(operand % 8);
        case OpCode.bdv:
          b = a ~/ math.pow(2, operand);
        case OpCode.cdv:
          c = a ~/ math.pow(2, operand);
      }

      _index++;
    }

    return result;
  }

  /// Returns the operand value given an [OpCode]. Operands are either
  /// literal (the raw value of the operand), or compound based on a
  /// set of rules, depending on the opcode.
  int _getOperandValue(OpCode opCode, int operand) {
    switch (opCode) {
      // Compound operands
      case OpCode.adv:
      case OpCode.bst:
      case OpCode.out:
      case OpCode.bdv:
      case OpCode.cdv:
        return switch (operand) {
          <= 3 => operand,
          4 => a,
          5 => b,
          6 => c,
          _ => throw Exception('Invalid compound operand'),
        };

      // Literal operands
      case OpCode.bxl:
      case OpCode.jnz:
        return operand;

      // Special case: operand is ignored for the bxc instruction.
      case OpCode.bxc:
        return 0;
    }
  }
}

/// Loads the initial state of the computer registers and the loaded program.
Future<Computer> loadData(File file) async {
  final lines = await file.readAsLines();
  return loadDataFromLines(lines);
}

/// Loads the data from a list of lines, useful for tests providing other input.
Computer loadDataFromLines(List<String> lines) {
  final a = int.parse(lines[0].split(' ')[2]);
  final b = int.parse(lines[1].split(' ')[2]);
  final c = int.parse(lines[2].split(' ')[2]);

  final instructionsStr = lines[4].split(' ')[1];
  final instructions = <Instruction>[];
  final program = instructionsStr.split(',').map(int.parse).toList();
  for (int i = 0; i < program.length; i += 2) {
    instructions.add(Instruction.fromInput(program[i], program[i + 1]));
  }

  return Computer(a, b, c, instructions, instructionsStr);
}
