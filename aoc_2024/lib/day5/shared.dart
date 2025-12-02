import 'dart:io';

import 'package:collection/collection.dart';

/// A rules graph is a map of page numbers to page nodes.
/// The page node contains the page number, and a list of
/// page nodes that are allowed to appear after that page.
typedef RulesGraph = Map<int, PageNode>;

/// Represents a node in the rules graph.
final class PageNode {
  /// This page's number.
  final int page;

  /// Thie list of page nodes that are allowed to appear after
  /// this page.
  final List<PageNode> after = [];

  PageNode({required this.page});
}

/// Represents the data for this problem, which is a list of
/// rules and a list of updates.
final class Contents {
  final RulesGraph rules;
  final List<Update> updates;

  Contents({required this.rules, required this.updates});

  /// Constructs a rules graph from a given list of rules, and returns
  /// a [Contents] instance containing the rules graph and a list of
  /// updates.
  factory Contents.fromRulesList({
    required List<Rule> rules,
    required List<Update> updates,
  }) {
    final graph = <int, PageNode>{};

    for (final rule in rules) {
      final beforeNode = graph.putIfAbsent(
        rule.before,
        () => PageNode(page: rule.before),
      );
      final afterNode = graph.putIfAbsent(
        rule.after,
        () => PageNode(page: rule.after),
      );

      beforeNode.after.add(afterNode);
    }

    return Contents(rules: graph, updates: updates);
  }
}

/// Represents a page rule, which is a declaration that a
/// given page number must always appear before another
/// page number.
final class Rule {
  final int before;
  final int after;

  Rule({required this.before, required this.after});

  /// Convenience factory to build a [Rule] from a list of two pages.
  factory Rule.fromList(List<int> pages) {
    assert(pages.length == 2, 'Expect exactly two pages');
    return Rule(before: pages[0], after: pages[1]);
  }
}

/// Represents an update, which has a list of page numbers.
final class Update {
  final List<int> pages;

  Update({required this.pages});

  /// Returns the middle page value for the update.
  int get middle {
    assert(
      pages.length.isOdd,
      'This should only be called with an odd number of pages',
    );
    return pages[(pages.length / 2).floor()];
  }

  /// Returns true if this update is valid, given the provided
  /// rules graph.
  bool isValid({required final RulesGraph rules}) {
    var node = rules[pages[0]];

    var i = 1;
    while (node != null && i < pages.length) {
      final page = pages[i];
      node = node.after.firstWhereOrNull((n) => n.page == page);
      if (node != null) i++;
    }

    return i >= pages.length;
  }

  /// Uses the rules in the rules graph to sort this update's
  /// page values.
  void sortViaRules({required final RulesGraph rules}) {
    pages.sort((a, b) {
      final nodeA = rules[a];
      final nodeB = rules[b];

      return nodeA!.after.contains(nodeB) ? -1 : 1;
    });
  }
}

/// Loads data from file, with each line represents as
/// a string in the list.
Future<Contents> loadData(File file) async {
  final lines = await file.readAsLines();

  final rules = <Rule>[];
  final updates = <Update>[];

  // Tracker whether we are parsing updates. If false, we
  // are still parsing rules.
  var parsingUpdates = false;

  for (final line in lines) {
    if (parsingUpdates) {
      updates.add(Update(pages: line.split(',').map(int.parse).toList()));
    } else if (line == '') {
      // When we encounter the empty line, switch from parsing rules to
      // parsing updates.
      parsingUpdates = true;
    } else {
      rules.add(Rule.fromList(line.split('|').map(int.parse).toList()));
    }
  }

  return Contents.fromRulesList(rules: rules, updates: updates);
}
