import 'package:flutter/material.dart';

class UnitSelector extends StatelessWidget {
  const UnitSelector({
    super.key,
    required this.value,
    required this.cardio,
    required this.onChanged,
  });

  final String value;
  final bool cardio;
  final Function(String?) onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: const InputDecoration(labelText: 'Unit'),
      items: (cardio ? ['km', 'mi'] : ['kg', 'lb']).map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? newValue) {
        onChanged(newValue);
      },
    );
  }
}
