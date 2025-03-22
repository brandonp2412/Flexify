import 'package:flutter/material.dart';

class UnitSelector extends StatelessWidget {
  final String? value;
  final String? label;
  final bool? settings;

  final Function(String?) onChanged;
  const UnitSelector({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
    this.settings,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      DropdownMenuItem(
        value: 'km',
        child: Text("Kilometers (km)"),
      ),
      DropdownMenuItem(
        value: 'mi',
        child: Text("Miles (mi)"),
      ),
      DropdownMenuItem(
        value: 'm',
        child: Text("Meters (m)"),
      ),
      DropdownMenuItem(
        value: 'kcal',
        child: Text("Kilocalories (kcal)"),
      ),
      DropdownMenuItem(
        value: 'kg',
        child: Text("Kilograms (kg)"),
      ),
      DropdownMenuItem(
        value: 'lb',
        child: Text("Pounds (lb)"),
      ),
    ];

    if (settings == true) {
      items.insert(
        0,
        DropdownMenuItem(
          value: "last-entry",
          child: Text("Last entry"),
        ),
      );
    }

    return DropdownButtonFormField(
      decoration: InputDecoration(labelText: label ?? 'Unit'),
      value: value,
      items: items,
      onChanged: (value) {
        onChanged(value);
      },
    );
  }
}
