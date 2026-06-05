import 'package:flexify/utils.dart';
import 'package:flutter/material.dart';

/// A numeric [TextFormField] flanked by `-` / `+` buttons for keyboard-free
/// entry. Tapping a button adjusts the value by [step]; long-pressing adjusts
/// it by [longPressStep] (defaults to four times [step]) for larger jumps.
/// The value is clamped to be non-negative and formatted via [toString].
class StepperField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final double step;
  final double? longPressStep;
  final Widget? suffixIcon;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final void Function(String)? onFieldSubmitted;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;

  const StepperField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.step,
    this.longPressStep,
    this.suffixIcon,
    this.focusNode,
    this.textInputAction,
    this.onFieldSubmitted,
    this.onChanged,
    this.validator,
  });

  void _bump(double delta) {
    final next = ((double.tryParse(controller.text) ?? 0) + delta)
        .clamp(0, double.infinity)
        .toDouble();
    final text = toString(next);
    controller.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
    onChanged?.call(text);
  }

  @override
  Widget build(BuildContext context) {
    final big = longPressStep ?? step * 4;

    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: controller,
            focusNode: focusNode,
            decoration: InputDecoration(
              labelText: labelText,
              suffixIcon: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  suffixIcon ?? SizedBox(),
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: () => _bump(-step),
                    onLongPress: () => _bump(-big),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () => _bump(step),
                    onLongPress: () => _bump(big),
                  ),
                ],
              ),
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            textInputAction: textInputAction,
            onTap: () => selectAll(controller),
            onChanged: onChanged,
            onFieldSubmitted: onFieldSubmitted,
            validator: validator,
          ),
        ),
      ],
    );
  }
}
