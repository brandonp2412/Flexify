import 'dart:io';

import 'package:path_provider/path_provider.dart';

const updateNoticeCooldown = Duration(days: 14);

bool isUpdateNoticeDue(DateTime now, DateTime? lastShown) =>
    lastShown == null || now.difference(lastShown) >= updateNoticeCooldown;

Future<bool> claimUpdateNotice({File? storage, DateTime? at}) async {
  final file =
      storage ??
      File(
        '${(await getApplicationSupportDirectory()).path}${Platform.pathSeparator}last_update_notice_ms',
      );
  final stored = await file.exists() ? await file.readAsString() : '';
  final lastShownMs = int.tryParse(stored.trim());
  final lastShown = lastShownMs == null
      ? null
      : DateTime.fromMillisecondsSinceEpoch(lastShownMs);
  final now = at ?? DateTime.now();
  if (!isUpdateNoticeDue(now, lastShown)) return false;
  await file.parent.create(recursive: true);
  await file.writeAsString('${now.millisecondsSinceEpoch}', flush: true);
  return true;
}
