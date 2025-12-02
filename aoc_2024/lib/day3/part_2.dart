import 'dart:io';

import 'shared.dart';

/// Extract do/don't instructions, along with multiplication
/// statements, and compute the sum of all of those statements.
///
/// `do()` and `don't` instructions enable or disable all
/// multiplications that follow (until the next instruction is
/// encountered).
Future<int> calculate(File file) async {
  final data = await loadData(file);

  var value = 0;
  var ignore = false;
  for (final instruction in data) {
    switch (instruction.runtimeType) {
      case == Do:
        ignore = false;
      case == Dont:
        ignore = true;
      case == Mult:
        if (!ignore) {
          value += (instruction as Mult).product;
        }
    }
  }
  return value;
}
