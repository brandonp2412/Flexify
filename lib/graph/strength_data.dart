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

typedef StrengthDataLookupKey = ({String? category, DateTime created});

Map<StrengthDataLookupKey, StrengthData> indexStrengthDataByCategoryAndDate(
  Iterable<StrengthData> data,
) => {
  for (final row in data) (category: row.category, created: row.created): row,
};

Map<String?, List<StrengthData>> groupStrengthDataByCategory(
  Iterable<StrengthData> data,
) {
  final grouped = <String?, List<StrengthData>>{};
  for (final row in data) {
    (grouped[row.category] ??= <StrengthData>[]).add(row);
  }
  return grouped;
}
