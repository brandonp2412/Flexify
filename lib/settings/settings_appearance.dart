import 'package:flexify/settings/settings_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

List<Widget> getAppearances(String term, SettingsState settings) {
  return [
    if ('theme'.contains(term.toLowerCase()))
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: DropdownButtonFormField<ThemeMode>(
          value: settings.themeMode,
          decoration: const InputDecoration(
            labelStyle: TextStyle(),
            labelText: 'Theme',
          ),
          items: const [
            DropdownMenuItem(
              value: ThemeMode.system,
              child: Text("System"),
            ),
            DropdownMenuItem(
              value: ThemeMode.dark,
              child: Text("Dark"),
            ),
            DropdownMenuItem(
              value: ThemeMode.light,
              child: Text("Light"),
            ),
          ],
          onChanged: (value) => settings.setTheme(value!),
        ),
      ),
    if ('system color scheme'.contains(term.toLowerCase()))
      Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: ListTile(
          title: const Text('System color scheme'),
          leading: settings.systemColors
              ? const Icon(Icons.color_lens)
              : const Icon(Icons.color_lens_outlined),
          onTap: () => settings.setSystem(!settings.systemColors),
          trailing: Switch(
            value: settings.systemColors,
            onChanged: (value) => settings.setSystem(value),
          ),
        ),
      ),
    if ('show images'.contains(term.toLowerCase()))
      ListTile(
        title: const Text('Show images'),
        leading: settings.showImages
            ? const Icon(Icons.image)
            : const Icon(Icons.image_outlined),
        onTap: () => settings.setShowImages(!settings.showImages),
        trailing: Switch(
          value: settings.showImages,
          onChanged: (value) => settings.setShowImages(value),
        ),
      ),
    if ('curve line graphs'.contains(term.toLowerCase()))
      ListTile(
        title: const Text('Curve line graphs'),
        leading: const Icon(Icons.insights),
        onTap: () => settings.setCurvedLines(!settings.curveLines),
        trailing: Switch(
          value: settings.curveLines,
          onChanged: (value) => settings.setCurvedLines(value),
        ),
      ),
  ];
}

class SettingsAppearance extends StatelessWidget {
  const SettingsAppearance({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Appearance"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: getAppearances('', settings),
        ),
      ),
    );
  }
}
