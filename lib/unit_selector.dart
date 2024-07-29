import 'package:flutter/material.dart';

class UnitSelector extends StatelessWidget {
  final String? value;
  final String? label;

  final bool cardio;
  final Function(String?) onChanged;
  const UnitSelector({
    super.key,
    required this.value,
    required this.cardio,
    required this.onChanged,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    if (cardio)
      return DropdownButtonFormField(
        decoration: InputDecoration(labelText: label ?? 'Unit'),
        value: value,
        items: const [
          DropdownMenuItem(
            value: '',
            child: Text(""),
          ),
          DropdownMenuItem(
            value: 'km',
            child: Text("Kilometers"),
          ),
          DropdownMenuItem(
            value: 'mi',
            child: Text("Miles"),
          ),
          DropdownMenuItem(
            value: 'm',
            child: Text("Meters"),
          ),
          DropdownMenuItem(
            value: 'kcal',
            child: Text("Kilocalories"),
          ),
        ],
        onChanged: (value) {
          onChanged(value);
        },
      );
    return DropdownButtonFormField(
      decoration: InputDecoration(labelText: label ?? 'Unit'),
      value: value,
      items: const [
        DropdownMenuItem(
          value: null,
          child: Text(""),
        ),
        DropdownMenuItem(
          value: 'kg',
          child: Text("Kilograms"),
        ),
        DropdownMenuItem(
          value: 'lb',
          child: Text("Pounds"),
        ),
      ],
      onChanged: (value) {
        onChanged(value);
      },
    );
  }
}
