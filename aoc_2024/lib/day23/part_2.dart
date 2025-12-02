import 'dart:io';

import 'package:collection/collection.dart';

import 'shared.dart';

final setEquality = const SetEquality<String>();
final setEquals = setEquality.equals;

/// Represents an interconnected group of computers.
final class Group {
  final Set<String> computers;

  Group(String name, String connection) : computers = {} {
    computers.add(name);
    computers.add(connection);
  }

  Group.fromSet(this.computers);

  /// Returns true if the group contains the specified pair of computers.
  bool containsPair(String a, String b) =>
      computers.contains(a) && computers.contains(b);

  /// Add a new computer to this group.
  void add(String name) {
    computers.add(name);
  }

  @override
  bool operator ==(Object other) {
    if (other is Group) {
      return setEquals(computers, other.computers);
    }
    return false;
  }

  @override
  int get hashCode => setEquality.hash(computers);

  @override
  String toString() => computers.sorted().join(',');
}

/// Continuing from part 1, rather than finding all groups of three computers,
/// find the largest interconnected group.
///
/// Return the sorted, comma-separated list of all computers in that group.
Future<String> calculate(File file) async {
  final network = await loadData(file);

  Set<Group> groups = {};
  for (final computer in network.entries) {
    final connections = computer.value;
    for (final connection in connections) {
      final existingGroups = groups
          .where((g) => g.containsPair(computer.key, connection))
          .toList();
      // If we haven't encountered this pair before, add a new group
      // and continue to the new pair.
      if (existingGroups.isEmpty) {
        final group = Group(computer.key, connection);
        groups.add(group);
        continue;
      }

      // For each group containing this pair, check which potential connections
      // are also interconnected with this group.
      for (final existingGroup in existingGroups) {
        // Find all potential connections to this group. Start with the union of
        // all of the group members' connections, filtering out the group
        // members themselves.
        var allPotentialConnections = existingGroup.computers
            .fold(<String>{}, (e, v) => e.union(network[v]!))
            .where((c) => !existingGroup.computers.contains(c));

        // For all potential connections, if they connect to every computer in
        // the group, update the group with the new connection.
        for (final potentialConnection in allPotentialConnections) {
          if (existingGroup.computers.every(
            (c) => network[c]!.contains(potentialConnection),
          )) {
            // Remove and readd the group. This prevents adding a duplicate
            // entry to the set, since modifying the group while it is in the
            // set would not trigger any logic in the set to remove the
            // duplicate.
            groups.remove(existingGroup);
            existingGroup.add(potentialConnection);
            groups.add(existingGroup);
          }
        }
      }
    }
  }

  return groups
      .sorted((g1, g2) => g2.computers.length.compareTo(g1.computers.length))
      .first
      .toString();
}
