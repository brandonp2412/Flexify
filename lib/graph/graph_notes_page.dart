import 'package:flutter/material.dart';

/// A full-screen editor for an exercise's notes.
///
/// The text field fills the page and the keyboard sits beneath it, so editing
/// notes never squashes the graph behind it. Edits are written straight to the
/// shared [controller]; [onChanged] fires on each keystroke so the caller can
/// persist them.
class GraphNotesPage extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onChanged;

  const GraphNotesPage({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise notes'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            controller: controller,
            onChanged: (_) => onChanged(),
            autofocus: true,
            expands: true,
            maxLines: null,
            minLines: null,
            textAlignVertical: TextAlignVertical.top,
            keyboardType: TextInputType.multiline,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Notes for this exercise',
            ),
          ),
        ),
      ),
    );
  }
}
