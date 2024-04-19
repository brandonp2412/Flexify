import 'package:flexify/constants.dart';

class GraphData {
  final DateTime created;
  final double reps;
  final double maxWeight;
  final double volume;
  final double oneRepMax;
  final String unit;
  final double relativeStrength;

  GraphData(
      {required this.created,
      required this.reps,
      required this.maxWeight,
      required this.volume,
      required this.oneRepMax,
      required this.relativeStrength,
      required this.unit});

  double getValue(Metric metric) {
    if (metric == Metric.oneRepMax) {
      return oneRepMax;
    } else if (metric == Metric.volume) {
      return volume;
    } else if (metric == Metric.relativeStrength) {
      return relativeStrength;
    } else if (metric == Metric.bestWeight) {
      return maxWeight;
    } else {
      throw Exception("Metric not supported.");
    }
  }
}
