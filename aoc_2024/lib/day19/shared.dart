import 'dart:io';

/// Represents the towels in a hot spring onsen.
final class Towels {
  /// List of towels available. Each towel has a set of stripes.
  final List<String> towels;

  /// List of target patterns, which is a sequence of stripes. These patterns
  /// may be made up of one or more towels, and may not even be feasible to
  /// construct from the available towels.
  final List<String> patterns;

  Towels(this.towels, this.patterns);
}

/// Loads the towels and patterns from a file.
Future<Towels> loadData(File file) async {
  final lines = await file.readAsLines();
  final towels = lines[0].split(',').map((s) => s.trim()).toList();
  return Towels(towels, lines.sublist(2, lines.length));
}
