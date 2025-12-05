import 'dart:io';

import 'shared.dart';

/// --- Day 5: Cafeteria ---
///
/// Given a kitchen with ingredient ids, and a list of ranges that denote
/// which ids are for fresh ingredients, return the number of ingredients
/// that are fresh.
Future<int> calculate(File file) async {
  final kitchen = await loadData(file);
  return kitchen.freshIngredients.length;
}
