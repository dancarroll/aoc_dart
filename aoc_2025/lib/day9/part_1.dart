import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:aoc_shared/shared.dart';

import 'shared.dart';

/// --- Day 9: Movie Theater ---
///
/// Given an input of points, calculate the largest possible rectangle
/// (by area) that can be made from any two corner points.
Future<int> calculate(File file) async {
  final input = await loadData(file);

  final mostSeparatedPoints = pairs(input)
      .map((pair) => (pair.$1, pair.$2, area(pair.$1, pair.$2)))
      .sortedBy((record) => record.$3)
      .reversed;

  return mostSeparatedPoints.first.$3;
}

/// Calculates the rectangular area given the two corner points.
int area(Point<int> a, Point<int> b) =>
    ((b.x - a.x).abs() + 1) * ((b.y - a.y).abs() + 1);
