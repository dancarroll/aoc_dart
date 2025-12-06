/// Represents the operator of an equation.
enum Operator {
  unknown,
  add,
  multiply;

  /// Parses the operator from a string representation.
  factory Operator.fromString(String s) => switch (s) {
    '+' => Operator.add,
    '*' => Operator.multiply,
    _ => Operator.unknown,
  };

  /// Performs the operation on two values.
  int operate(int a, int b) => switch (this) {
    add => a + b,
    multiply => a * b,
    unknown => throw UnsupportedError('Unknown operator'),
  };
}

/// Represents an equation with several operands, and an
/// operator that should be applied to each.
final class Equation {
  final List<int> operands;
  Operator operator;

  Equation(this.operands, this.operator);

  factory Equation.empty() => Equation([], Operator.unknown);

  /// Evaluates the operation.
  int evaluate() {
    int value = operands[0];
    for (int i = 1; i < operands.length; i++) {
      value = operator.operate(value, operands[i]);
    }
    return value;
  }
}
