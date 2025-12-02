import 'dart:math';

import 'package:aoc_shared/shared.dart';

import 'shared.dart';

/// Represents a step in the maze.
enum Step { straight, turn }

/// Represents the heading of a reindeer in the maze.
enum Heading {
  up,
  right,
  down,
  left;

  /// Calculates the new point based on a given point and this heading.
  Point<int> move(Point<int> point) => switch (this) {
    up => Point(point.x, point.y - 1),
    down => Point(point.x, point.y + 1),
    left => Point(point.x - 1, point.y),
    right => Point(point.x + 1, point.y),
  };

  /// Returns a new heading representing a clockwise 90 degree rotation.
  Heading rotateClockwise() {
    var nextIndex = index + 1;
    if (nextIndex >= Heading.values.length) {
      nextIndex = 0;
    }
    return Heading.values[nextIndex];
  }

  /// Returns a new heading representing a counter-clockwise 90 degree rotation.
  Heading rotateCounterclockwise() {
    var nextIndex = index - 1;
    if (nextIndex < 0) {
      nextIndex = Heading.values.length - 1;
    }
    return Heading.values[nextIndex];
  }
}

/// Represents a location and heading of a reindeer in the maze.
typedef ReindeerLocation = ({Heading heading, Point<int> point});

/// Represents a potential next step along a path.
typedef NextStep = ({Step step, ReindeerLocation location});

/// Represents a candidate for the best path in the maze.
final class CandidatePath implements Comparable<CandidatePath> {
  /// Static counter the increments for every created candidate path.
  /// This is used for a simple comparison during equality checking.
  static int _pathCounter = 0;

  /// Set of all points visited in this path so far.
  final Set<Point<int>> visited;

  /// List of steps taken to get to the current position.
  final List<Step> steps;

  /// Current position and heading of the reindeer along this path.
  ReindeerLocation current;

  /// Unique index of the path
  final int _index;

  /// Current score of the path. This is updated during each move,
  /// rather than being calculated on the fly, since the score is used
  /// for sorting the candidate list.
  int _score;

  CandidatePath(this.visited, this.steps, this.current, {score = 0})
    : _index = _pathCounter++,
      _score = score;

  /// Creates a new candidate from an existing candidate, by copying its
  /// list of visited points and steps.
  factory CandidatePath.fromCandidate(CandidatePath other) {
    return CandidatePath(
      {...other.visited},
      [...other.steps],
      other.current,
      score: other._score,
    );
  }

  /// Returns the current score of this path.
  int get score => _score;

  /// Incorporates the given [nextStep] along this path, including updating
  /// the path score.
  void step(NextStep nextStep) {
    // Track that the next position has been visited, and is the new current.
    current = nextStep.location;
    visited.add(nextStep.location.point);

    switch (nextStep.step) {
      case Step.straight:
        steps.add(nextStep.step);
        _score += 1;
      case Step.turn:
        // Any turn is really two steps: a turn, followed by moving straight
        // into the new location.
        steps.add(nextStep.step);
        steps.add(Step.straight);
        // Add 1001 to the score: 1000 for the turn, 1 for the straight move.
        _score += 1001;
    }
  }

  @override
  int get hashCode => _index;

  @override
  bool operator ==(Object other) =>
      (other is CandidatePath) ? _index == other._index : false;

  @override
  int compareTo(CandidatePath other) => score.compareTo(other.score);
}

/// Finds a lowest cost path through the given maze.
CandidatePath findBestPath(Maze maze) {
  return findBestPaths(maze, stopAfterFirst: true)[0];
}

/// Finds all of the lowest cost paths through the given maze.
List<CandidatePath> findBestPaths(Maze maze, {bool stopAfterFirst = false}) {
  // Prime the list of candidate paths with the starting point.
  final paths = [
    CandidatePath(
      {maze.start},
      [],
      (heading: Heading.right, point: maze.start),
    ),
  ];
  final completedPaths = <CandidatePath>[];

  // For each location encountered, store the lowest score so far.
  // If we ever have a path that reaches a point with a higher score,
  // that path can be discarded.
  //
  // Note that this map is using both heading and point as a key, rather than
  // just a point. It is possible to encounter a point going in the wrong
  // direction that is less expensive than another path going in the correct
  // direction.
  Map<ReindeerLocation, int> lowestPointScores = {};

  // Iterate through all paths, until one of the following conditions occurs:
  // - We run out of paths: this can occur as paths are moved to completed,
  //   or pruned because they are guaranteed to not produce a lower cost path.
  // - We have a completed path of lower cost than all of the pending paths.
  //   Since paths are maintained in a sorted order, we just need to check the
  //   first pending path.
  // - If [stopAfterFirst] is true, the inner loop logic will short-circuit as
  //   soon as the first completed path is detected.
  mainController:
  while (paths.isNotEmpty &&
      (completedPaths.isEmpty || completedPaths[0].score > paths[0].score)) {
    // Keep track of any paths we encounter that are no longer relevant.
    List<CandidatePath> pathsToPrune = [];

    // In this iteration, progress each of the lowest score paths by one step.
    // This is a slight optimization, as it avoids multiple expensive sorts in
    // the case that there are many paths with the lowest score so far.
    int lowestScore = paths[0].score;
    final currIterationPaths = <CandidatePath>[];
    int i = 0;
    while (i < paths.length && paths[i].score == lowestScore) {
      currIterationPaths.add(paths[i]);
      i++;
    }

    for (final path in currIterationPaths) {
      // Determine whether we have already reached the path's current point
      // at a cheaper cost. If so, this path cannot be the best path, so
      // mark it to be discarded.
      //
      // If the score is a tie, keep both paths.
      final lowestScore = lowestPointScores[path.current] ?? maxInt;
      if (lowestScore < path.score) {
        pathsToPrune.add(path);
        continue;
      } else if (lowestScore > path.score) {
        lowestPointScores[path.current] = path.score;
      }

      // We are iterating along the lowest score path. If this path has already
      // reached the end, the means we are at the end! Break out of the loop.
      if (path.current.point == maze.end) {
        pathsToPrune.add(path);
        completedPaths.add(path);

        if (stopAfterFirst) break mainController;
        continue;
      }

      // Find all of the possible next steps along the current path.
      final nextSteps = _getValidStepsFromPoint(
        maze,
        path.current,
        path.visited,
      );
      if (nextSteps.isNotEmpty) {
        // For any additional valid steps, branch off a new candidate path.
        for (int i = 1; i < nextSteps.length; i++) {
          final newCandidate = CandidatePath.fromCandidate(path);
          newCandidate.step(nextSteps[i]);
          paths.add(newCandidate);
        }

        // Use the first step option on the current candidate path.
        // This is done after adding the new candidate paths, since the logic
        // above copies this path's list of steps/visited.
        path.step(nextSteps[0]);
      } else {
        // No additional steps along this path, so prune it. A path that already
        // reached the end would have been checked earlier.
        pathsToPrune.add(path);
      }
    }

    // Remove paths that are no longer potential best paths.
    for (final pathToPrune in pathsToPrune) {
      paths.remove(pathToPrune);
    }

    // Sort the paths. This is necessary, over using some sort of SortedList
    // data structure, because the scores in the CandidatePaths change
    // over time.
    paths.sort();
  }

  return completedPaths;
}

/// Determines all of the valid next steps from a given path.
///
/// Rather than accepting a [CandidatePath], this function just accepts the
/// reindeer position and a set of visited points.
///
/// In reality, this function should never return more than 3 points (since
/// only moves in cardinal directions are allowed, and one of those 4 directions
/// would have already been visited).
List<NextStep> _getValidStepsFromPoint(
  Maze maze,
  ReindeerLocation current,
  Set<Point<int>> visited,
) {
  // Given the only potential moves (straight, clockwise, counterclockwise)
  return [
        (current.heading, Step.straight),
        (current.heading.rotateClockwise(), Step.turn),
        (current.heading.rotateCounterclockwise(), Step.turn),
      ]
      // Generate the corresponding steps.
      .map(
        (h) => (
          step: h.$2,
          location: (heading: h.$1, point: h.$1.move(current.point)),
        ),
      )
      // Filter out any step that would visit a visited point.
      .where((ns) => !visited.contains(ns.location.point))
      // Limit to steps that would land on empty spaces or the end.
      .where(
        (ns) =>
            maze.map[ns.location.point] == Location.empty ||
            maze.map[ns.location.point] == Location.end,
      )
      // Convert to a list (since it will later be indexed).
      .toList();
}
