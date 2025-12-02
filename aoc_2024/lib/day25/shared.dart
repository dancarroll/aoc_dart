import 'dart:io';

/// Enum to keep track of the input processing state.
enum ProcessingState { unknown, lock, key }

typedef Data = ({List<List<int>> locks, List<List<int>> keys});

/// Loads the lock and key data from a file.
Future<Data> loadData(File file) async {
  final lines = await file.readAsLines();

  List<List<int>> locks = [];
  List<List<int>> keys = [];

  // Since key and lock schematics always have an entire filled row,
  // just initialize the list spots to -1, so those will zero out.
  List<int> initialSchematic() => List.filled(5, -1);

  List<int> processing = initialSchematic();
  var state = ProcessingState.unknown;

  void finalizeProcessing() {
    switch (state) {
      case ProcessingState.key:
        keys.add(processing);
      case ProcessingState.lock:
        locks.add(processing);
      default:
        throw Exception('Unexpected state');
    }

    state = ProcessingState.unknown;
    processing = initialSchematic();
  }

  for (final line in lines) {
    if (line.isEmpty) {
      finalizeProcessing();
      continue;
    }

    final lineChars = line.split('');
    if (state == ProcessingState.unknown) {
      state = switch (lineChars[0]) {
        '#' => ProcessingState.lock,
        '.' => ProcessingState.key,
        _ => throw Exception('Unexpected char'),
      };
    }

    for (int i = 0; i < lineChars.length; i++) {
      if (lineChars[i] == '#') {
        processing[i]++;
      }
    }
  }

  // Also accept the last input processed.
  finalizeProcessing();

  return (locks: locks, keys: keys);
}
