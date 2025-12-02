import 'dart:io';

import 'shared.dart';

/// --- Day 23: LAN Party ---
///
/// Given a list of computer connections (ab-cd), determine how many groups of
/// three computers are connected to each other. Limit this search to groups
/// that contain a computer starting with the letter 't'.
///
/// Return the number of groups.
Future<int> calculate(File file) async {
  final network = await loadData(file);

  Set<(String, String, String)> triplets = {};
  for (final computer in network.entries) {
    // Limit our search to computers starting with the letter 't'.
    if (!computer.key.startsWith('t')) continue;

    final connections = computer.value;
    for (final connection in connections) {
      // Find all of the third partners for this pair of computers by:
      // - Calculate all of the valid third partners by taking the second
      //   computers connections and removing the first computer
      // - Then, look at the intersection of of the valid third partners with
      //   the first computer's connections.
      final lookingForPartners = connections.difference({computer.key});
      for (final third in network[connection]!.intersection(
        lookingForPartners,
      )) {
        // In order to avoid duplicates, sort the list of three computers
        // before adding it to the set.
        final triplet = [computer.key, connection, third]..sort();
        triplets.add((triplet[0], triplet[1], triplet[2]));
      }
    }
  }

  return triplets.length;
}
