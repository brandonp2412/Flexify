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
}
