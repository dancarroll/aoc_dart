import 'dart:io';

/// Represents the contents of the data, which are two
/// sorted lists of integers.
final class Contents {
  final List<int> listA;
  final List<int> listB;

  Contents(this.listA, this.listB);
}

/// Loads two columns of from a file, parses the columns
/// entries into integers, and sorts those lists
/// independently.
Future<Contents> loadData(File file) async {
  final lines = await file.readAsLines();

  final List<int> listA = [];
  final List<int> listB = [];

  for (final line in lines) {
    final values = line.split('   ');
    listA.add(int.parse(values[0]));
    listB.add(int.parse(values[1]));
  }
  listA.sort();
  listB.sort();

  return Contents(listA, listB);
}
