class StrengthData {
  final DateTime created;
  final double? reps;
  final String? unit;
  final double value;

  StrengthData({
    required this.created,
    required this.value,
    this.unit,
    this.reps,
  });
}
