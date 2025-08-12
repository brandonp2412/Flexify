import 'package:flexify/database/database.dart';
import 'package:flexify/settings/settings_state.dart';
import 'package:flexify/settings/update_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

List<Widget> getUpdateSettings(
  String term,
  Setting settings,
) {
  return [
    if ('update now'.contains(term.toLowerCase()))
      const Tooltip(
        message: 'Update the app now',
        child: UpdateButton(),
      ),
  ];
}

class UpdateSettings extends StatefulWidget {
  const UpdateSettings({super.key});

  @override
  State<UpdateSettings> createState() => _UpdateSettingsState();
}

class _UpdateSettingsState extends State<UpdateSettings> {
  late var settings = context.read<SettingsState>().value;

  @override
  Widget build(BuildContext context) {
    settings = context.watch<SettingsState>().value;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Updates"),
      ),
      body: ListView(
        children: getUpdateSettings('', settings),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
