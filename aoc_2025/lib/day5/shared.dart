import 'dart:io';

/// Represents a range of numbers.
final class Range {
  /// Start of the range, inclusive.
  final int start;

  /// End of the range, inclusive.
  final int end;

  Range(this.start, this.end);

  /// The numer of values in this range.
  int get size => end - start + 1;

  /// Returns whether the given value is within the range.
  bool isInRange(int value) => value >= start && value <= end;

  /// Returns the intersection of this range with the given range.
  /// If the ranges do not intersect, returns null.
  Range? intersection(Range other) {
    final largestStart = start > other.start ? start : other.start;
    final smallestEnd = end < other.end ? end : other.end;

    if (largestStart > smallestEnd) {
      return null;
    }
    return Range(largestStart, smallestEnd);
  }

  /// Returns the union of this range with the given range. If the
  /// ranges do not intersect, returns null;
  Range? union(Range other) {
    if (intersection(other) == null) {
      return null;
    }

    final smallestStart = start < other.start ? start : other.start;
    final largestEnd = end > other.end ? end : other.end;
    return Range(smallestStart, largestEnd);
  }
}

/// Represents the kitchen from the problem, which contains a list of
/// ingredient ids and list of id ranges that denote fresh ingredients.
final class Kitchen {
  final List<Range> freshIngredientRanges;
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

  List<Range> freshIngredientRanges = [];
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
        Range(int.parse(parts[0]), int.parse(parts[1])),
      );
    }
  }

  return Kitchen(freshIngredientRanges, ingredients);
}
