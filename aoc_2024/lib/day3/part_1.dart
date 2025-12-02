import 'dart:io';

import 'shared.dart';

/// Extract multiplication statements [`mul(123,456)`]
/// from text, and compute the sum of all of those statements.
///
/// Multiplication statements are located in a "corrupted"
/// text string, e.g.:
/// ```
/// xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))
/// ```
Future<int> calculate(File file) async {
  final data = await loadData(file);
  final val = data.whereType<Mult>().fold(0, (v, e) => v + e.product);
  return val;
}
