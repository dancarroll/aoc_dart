import 'dart:io';

import 'package:collection/collection.dart';
import 'package:aoc_shared/shared.dart';

import 'shared.dart';

/// --- Day 9: Movie Theater ---
///
/// Given an input of points, calculate the largest possible rectangle
/// (by area) that can be made from any two corner points.
Future<int> calculate(File file) async {
  final input = await loadData(file);

  return pairsLazy(input).map((pair) => area(pair.$1, pair.$2)).max;
}
