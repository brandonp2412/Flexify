class StrengthData {
  final DateTime created;
  final double reps;
  final String unit;
  final double value;
  final String? category;

  StrengthData({
    required this.created,
    required this.reps,
    required this.unit,
    required this.value,
    this.category,
  });
}
