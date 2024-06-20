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

  void _onTap() {
    if (value == 'kg')
      onChanged('lb');
    else if (value == 'km')
      onChanged('mi');
    else if (value == 'lb')
      onChanged('kg');
    else if (value == 'mi') onChanged('km');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 8.0),
        ListTile(
          title: Text('Unit ($value)'),
          leading: value == 'kg' || value == 'km'
              ? const Icon(Icons.straighten)
              : const Icon(Icons.square_foot),
          onTap: _onTap,
          trailing: Switch(
            value: value == 'kg' || value == 'km',
            onChanged: (_) => _onTap(),
          ),
        ),
      ],
    );
  }
}
