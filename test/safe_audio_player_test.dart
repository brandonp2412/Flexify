import 'package:flexify/audio/safe_audio_player.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('disabled audio player stays inert', () async {
    final player = SafeAudioPlayer(enabled: false);

    expect(player.isAvailable, isFalse);
    await player.playAsset('argon.mp3');
    await player.playFile('/tmp/alarm.mp3');
    await player.stop();
    await player.dispose();
  });
}
