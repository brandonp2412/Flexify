import 'package:flutter/material.dart';

class UnitSelector extends StatelessWidget {
  final String? value;
  final String? label;

  final Function(String?) onChanged;
  const UnitSelector({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      decoration: InputDecoration(labelText: label ?? 'Unit'),
      value: value,
      items: const [
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
