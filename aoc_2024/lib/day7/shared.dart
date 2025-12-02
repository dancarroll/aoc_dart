import 'dart:io';

/// Represents an arbitrary equation component.
abstract class Component {}

/// Represents an operator within an equation.
abstract class Operator extends Component {}

/// Addition operator.
class Add extends Operator {
  @override
  String toString() => '+';
}

/// Multiplication operator.
class Multiply extends Operator {
  @override
  String toString() => '*';
}

/// Concatenation operator (concatenates the numbers on
/// the left and right side to make a new number).
class Concatenation extends Operator {
  @override
  String toString() => '||';
}

/// Identity operator, which just copies the next number in
/// the equation.
class Identity extends Operator {}

/// Represents a numerical value operand.
class Value extends Component {
  final int num;

  Value(this.num);

  @override
  String toString() => num.toString();
}

/// Represents an equation, which may or may not be valid.
final class Equation {
  final int statedResult;
  final List<Component> components;

  Equation({required this.statedResult, required this.components});

  /// Computes the result of the equation, and returns true if the value
  /// matches the equations stated result.
  bool isValid() {
    return compute() == statedResult;
  }

  /// Computes the actual result of the equation.
  int compute() {
    var computedResult = 0;
    Operator operator = Identity();

    for (final component in components) {
      if (component is Operator) {
        operator = component;
      } else if (component is Value) {
        switch (operator.runtimeType) {
          case == Identity:
            computedResult = component.num;
          case == Add:
            computedResult += component.num;
          case == Multiply:
            computedResult *= component.num;
          case == Concatenation:
            computedResult = int.parse('$computedResult${component.num}');
        }
      }
    }

    return computedResult;
  }

  @override
  String toString() =>
      '$statedResult: ${components.map((c) => c.toString()).join(' ')}';
}

/// Represents an ambiguous equation, which has a list of operands
/// but no operators.
final class AmbiguousEquation {
  final int statedResult;
  final List<int> operands;

  AmbiguousEquation({required this.statedResult, required this.operands});

  /// Returns true if any combination of the given operators would result
  /// in this equation being valid.
  bool canBeValid(List<Operator> operators) {
    return _generateValidOperators(operands.length - 1, operators, []);
  }

  /// Recursively generates a list of operator combinations and determines if
  /// any result in a valid equation.
  bool _generateValidOperators(
    int targetLength,
    List<Operator> operatorOptions,
    List<Operator> current,
  ) {
    if (current.length == targetLength) {
      return _checkEquationVal(current) == statedResult;
    } else if (current.isNotEmpty &&
        _checkEquationVal(current) > statedResult) {
      // Due to the valid operators, the equation value can only increase as
      // it is executed. As soon as the value exceeds the stated value, we
      // can stop processing this chain.
      return false;
    }

    return operatorOptions.any(
      (operator) => _generateValidOperators(targetLength, operatorOptions, [
        ...current,
        operator,
      ]),
    );
  }

  /// Checks the value of the equation given a (potential partial) set of
  /// operators. If not enough operators are specified to accomodate all
  /// of the operands, this will use as many operands as possible.
  int _checkEquationVal(final List<Operator> operators) {
    var components = <Component>[];

    components.add(Value(operands[0]));
    for (int i = 0; i < operators.length; i++) {
      components.add(operators[i]);
      components.add(Value(operands[i + 1]));
    }

    final equation = Equation(
      statedResult: statedResult,
      components: components,
    );
    return equation.compute();
  }
}

/// Loads data from file, with each line represents as
/// an equation.
Future<Iterable<AmbiguousEquation>> loadData(File file) async {
  final lines = await file.readAsLines();

  return lines.map((line) {
    final components = line.split(':');
    assert(components.length == 2, 'Only expect one semicolon in the input');

    final result = int.parse(components[0]);
    final operands = components[1].trim().split(' ').map(int.parse).toList();

    return AmbiguousEquation(statedResult: result, operands: operands);
  });
}
