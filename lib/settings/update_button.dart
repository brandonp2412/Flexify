import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateService {
  static const String githubApiUrl =
      'https://api.github.com/repos/brandonp2412/Flexify/releases/latest';
  static Future<Map<String, dynamic>?> checkForUpdates() async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String currentVersion = packageInfo.version;

      final response = await http.get(
        Uri.parse(githubApiUrl),
        headers: {
          'Accept': 'application/vnd.github.v3+json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        String latestVersion = data['tag_name'].replaceAll('v', '');

        if (_isNewerVersion(currentVersion, latestVersion)) {
          return {
            'hasUpdate': true,
            'currentVersion': currentVersion,
            'latestVersion': latestVersion,
            'downloadUrl': _getDownloadUrl(data['assets']),
            'releaseNotes': data['body'] ?? '',
            'releaseName': data['name'] ?? 'New Version Available',
          };
        }
      }
      return {'hasUpdate': false, 'currentVersion': currentVersion};
    } catch (e) {
      print('Error checking for updates: $e');
      return null;
    }
  }

  static bool _isNewerVersion(String current, String latest) {
    List<int> currentParts = current.split('.').map(int.parse).toList();
    List<int> latestParts = latest.split('.').map(int.parse).toList();

    while (currentParts.length < latestParts.length) currentParts.add(0);
    while (latestParts.length < currentParts.length) latestParts.add(0);

    for (int i = 0; i < currentParts.length; i++) {
      if (latestParts[i] > currentParts[i]) return true;
      if (latestParts[i] < currentParts[i]) return false;
    }
    return false;
  }

  static String? _getDownloadUrl(List<dynamic> assets) {
    for (var asset in assets) {
      String name = asset['name'].toLowerCase();

      if (Platform.isAndroid) {
        if (name == 'flexify.apk') {
          return asset['browser_download_url'];
        } else if (name.contains('apk') &&
            !name.contains('arm') &&
            !name.contains('x86')) {
          return asset['browser_download_url'];
        }
      } else if (Platform.isWindows &&
          (name.contains('windows') && name.endsWith('.zip'))) {
        return asset['browser_download_url'];
      } else if (Platform.isMacOS &&
          (name.endsWith('.dmg') || name.endsWith('.app.zip'))) {
        return asset['browser_download_url'];
      } else if (Platform.isLinux &&
          (name.contains('linux') && name.endsWith('.zip'))) {
        return asset['browser_download_url'];
      }
    }

    if (Platform.isAndroid) {
      for (var asset in assets) {
        String name = asset['name'].toLowerCase();
        if (name.endsWith('.apk')) {
          return asset['browser_download_url'];
        }
      }
    }

    return null;
  }

  static Future<bool> downloadAndInstallUpdate(String downloadUrl) async {
    try {
      if (Platform.isAndroid) {
        if (await Permission.storage.request().isGranted ||
            await Permission.manageExternalStorage.request().isGranted) {
          final response = await http.get(Uri.parse(downloadUrl));
          if (response.statusCode == 200) {
            final directory = await getExternalStorageDirectory();
            final file = File('${directory!.path}/flexify_update.apk');
            await file.writeAsBytes(response.bodyBytes);

            final uri = Uri.file(file.path);
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri);
              return true;
            }
          }
        }
      } else if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
        final response = await http.get(Uri.parse(downloadUrl));
        if (response.statusCode == 200) {
          final directory = await getDownloadsDirectory();
          if (directory != null) {
            String filename = downloadUrl.split('/').last;
            final file = File('${directory.path}/$filename');
            await file.writeAsBytes(response.bodyBytes);

            final uri = Uri.file(directory.path);
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri);
              return true;
            }
          }
        }
      } else {
        final uri = Uri.parse(downloadUrl);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri);
          return true;
        }
      }
    } catch (e) {
      print('Error downloading update: $e');
    }
    return false;
  }
}

class UpdateButton extends StatefulWidget {
  const UpdateButton({super.key});

  @override
  createState() => _UpdateButtonState();
}

class _UpdateButtonState extends State<UpdateButton> {
  bool _isChecking = false;
  Map<String, dynamic>? _updateInfo;

  Future<void> _checkForUpdates() async {
    setState(() {
      _isChecking = true;
    });

    final updateInfo = await UpdateService.checkForUpdates();

    setState(() {
      _isChecking = false;
      _updateInfo = updateInfo;
    });

    if (updateInfo != null) {
      if (updateInfo['hasUpdate'] == true) {
        _showUpdateDialog();
      } else {
        _showNoUpdateDialog();
      }
    } else {
      _showErrorDialog();
    }
  }

  void _showUpdateDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(_updateInfo!['releaseName']),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Current Version: ${_updateInfo!['currentVersion']}'),
              Text('Latest Version: ${_updateInfo!['latestVersion']}'),
              const SizedBox(height: 16),
              const Text(
                'Release Notes:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Container(
                height: 150,
                width: double.maxFinite,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4),
                ),
                padding: const EdgeInsets.all(8),
                child: SingleChildScrollView(
                  child: Text(
                    _updateInfo!['releaseNotes'] ??
                        'No release notes available.',
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Later'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _performUpdate();
              },
              child: const Text('Update Now'),
            ),
          ],
        );
      },
    );
  }

  void _showNoUpdateDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('No Updates Available'),
          content: Text(
            'You are running the latest version (${_updateInfo!['currentVersion']}).',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Update Check Failed'),
          content: const Text(
            'Unable to check for updates. Please check your internet connection and try again.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _performUpdate() async {
    final downloadUrl = _updateInfo!['downloadUrl'];
    if (downloadUrl != null) {
      final success = await UpdateService.downloadAndInstallUpdate(downloadUrl);
      if (!success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to download update. Opening in browser...'),
          ),
        );
        final uri = Uri.parse(
          'https://github.com/brandonp2412/Flexify/releases/latest',
        );
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: _isChecking ? null : _checkForUpdates,
      icon: _isChecking
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.system_update),
      label: Text(_isChecking ? 'Checking...' : 'Check for Updates'),
    );
  }
}
