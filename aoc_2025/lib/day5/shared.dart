import 'dart:io';

/// Represents a range of ingredients ids that are fresh.
final class FreshIngredientRange {
  /// Start of the range, inclusive.
  final int start;

  /// End of the range, inclusive.
  final int end;

  FreshIngredientRange(this.start, this.end);

  /// Returns whether the given value is within the range.
  bool isInRange(int value) => value >= start && value <= end;
}

/// Represents the kitchen from the problem, which contains a list of
/// ingredient ids and list of id ranges that denote fresh ingredients.
final class Kitchen {
  final List<FreshIngredientRange> freshIngredientRanges;
  final List<int> ingredients;

  Kitchen(this.freshIngredientRanges, this.ingredients);

  List<int> get freshIngredients => ingredients
      .where(
        (ingredient) =>
            freshIngredientRanges.any((range) => range.isInRange(ingredient)),
      )
      .toList();
}

Future<Kitchen> loadData(File file) async {
  final lines = await file.readAsLines();

  List<FreshIngredientRange> freshIngredientRanges = [];
  List<int> ingredients = [];

  // Keep track of whether the blank line was encountered, which
  // signals the separation between ingredient ranges and ingredients.
  bool parsingIngredients = false;
  for (final line in lines) {
    if (line.isEmpty) {
      parsingIngredients = true;
      continue;
    } else if (parsingIngredients) {
      ingredients.add(int.parse(line));
    } else {
      final parts = line.split('-');
      freshIngredientRanges.add(
        FreshIngredientRange(int.parse(parts[0]), int.parse(parts[1])),
      );
    }
  }

  return Kitchen(freshIngredientRanges, ingredients);
}
