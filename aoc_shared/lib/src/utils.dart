const int maxInt = -1 >>> 1;

List<(T, T)> pairs<T>(List<T> items) {
  List<(T, T)> records = [];
  for (int i = 0; i < items.length - 1; i++) {
    for (int j = i + 1; j < items.length; j++) {
      records.add((items[i], items[j]));
    }
  }
  return records;
}

List<(T, T)> orderedPairs<T>(List<T> items) {
  List<(T, T)> records = [];
  for (final itemA in items) {
    for (final itemB in items) {
      records.add((itemA, itemB));
    }
  }
  return records;
}

List<(T, T)> pairsFromIterables<T>(Iterable<T> one, Iterable<T> two) {
  List<(T, T)> records = [];
  for (final itemA in one) {
    for (final itemB in two) {
      records.add((itemA, itemB));
    }
  }
  return records;
}
