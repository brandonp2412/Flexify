import 'package:flexify/database/exercise_analytics.dart';
import 'package:flexify/graph/graphs_page.dart';
import 'package:flutter_test/flutter_test.dart';

List<GraphExerciseSummary> baseline(
  List<GraphExerciseSummary> source,
  String search,
  String? category,
) {
  final terms = search
      .toLowerCase()
      .split(' ')
      .where((term) => term.isNotEmpty);
  var stream = source.where(
    (summary) => category == null || summary.category == category,
  );
  for (final term in terms) {
    stream = stream.where((summary) => summary.normalizedName.contains(term));
  }
  return stream.toList();
}

void main() {
  test('graph filtering benchmark and equivalence', () {
    final source = List.generate(
      10000,
      (i) => GraphExerciseSummary(
        exerciseId: i,
        bodyWeight: false,
        name: 'Exercise ${i % 17} Bench Press Variation ${i % 31}',
        category: i.isEven ? 'Upper' : 'Lower',
        unit: 'kg',
        cardio: false,
        weight: 40,
        reps: 10,
        duration: 0,
        distance: 0,
        created: DateTime(2026),
      ),
    );
    const scenarios = [
      ('bench press', 'Upper'),
      ('exercise 1 variation', null),
      ('', 'Lower'),
    ];
    for (final (search, category) in scenarios) {
      expect(
        filterGraphSummaries(source, search, category),
        baseline(source, search, category),
      );
    }
    for (var i = 0; i < 10; i++) {
      baseline(source, 'bench press variation', 'Upper');
      filterGraphSummaries(source, 'bench press variation', 'Upper');
    }
    final emptySearch = Stopwatch()..start();
    for (var i = 0; i < 100000; i++) {
      filterGraphSummaries(const [], '', null);
    }
    emptySearch.stop();
    print('GRAPH_EMPTY_SEARCH_US=${emptySearch.elapsedMicroseconds}');
    final categoryOnly = Stopwatch()..start();
    for (var i = 0; i < 200; i++) {
      filterGraphSummaries(source, '', 'Upper');
    }
    categoryOnly.stop();
    print('GRAPH_CATEGORY_ONLY_US=${categoryOnly.elapsedMicroseconds}');
    final allItems = Stopwatch()..start();
    for (var i = 0; i < 200; i++) {
      filterGraphSummaries(source, '', null);
    }
    allItems.stop();
    print('GRAPH_ALL_ITEMS_US=${allItems.elapsedMicroseconds}');
    final oldTime = Stopwatch()..start();
    for (var i = 0; i < 100; i++) {
      baseline(source, 'bench press variation', 'Upper');
    }
    oldTime.stop();
    final newTime = Stopwatch()..start();
    for (var i = 0; i < 100; i++) {
      filterGraphSummaries(source, 'bench press variation', 'Upper');
    }
    newTime.stop();
    print('GRAPH_FILTER_BASELINE_US=${oldTime.elapsedMicroseconds}');
    print('GRAPH_FILTER_OPTIMIZED_US=${newTime.elapsedMicroseconds}');
  });
}
