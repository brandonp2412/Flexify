import 'package:audioplayers/audioplayers.dart';
import 'package:flexify/crash_logger.dart';
import 'package:flexify/logging.dart';

/// Lazily owns one native audio player.
///
/// This avoids initializing Windows Media Foundation until playback is needed.
/// See https://github.com/bluefireteam/audioplayers/pull/2019.
class SafeAudioPlayer {
  SafeAudioPlayer({this.enabled = true});

  final bool enabled;
  AudioPlayer? _player;

  /// Whether audio controls should be exposed on this platform.
  bool get isAvailable => enabled;

  Future<AudioPlayer?> _getPlayer() async {
    if (!enabled) return null;
    if (_player != null) return _player;

    try {
      final player = AudioPlayer();
      _player = player;
      return player;
    } catch (error, stackTrace) {
      talker.handle(error, stackTrace, 'Failed to create audio player');
      CrashLogger.instance?.record(
        error,
        stackTrace,
        context: 'audio.createPlayer',
      );
      return null;
    }
  }

  /// Plays a bundled asset when audio is available.
  Future<void> playAsset(String asset) async {
    await _play(AssetSource(asset));
  }

  /// Plays a file from the local filesystem when audio is available.
  Future<void> playFile(String path) async {
    await _play(DeviceFileSource(path));
  }

  Future<void> _play(Source source) async {
    try {
      final player = await _getPlayer();
      await player?.play(source);
    } catch (error, stackTrace) {
      talker.handle(error, stackTrace, 'Failed to play audio');
      CrashLogger.instance?.record(error, stackTrace, context: 'audio.play');
    }
  }

  /// Stops the native player if one has been created.
  Future<void> stop() async {
    try {
      await _player?.stop();
    } catch (error, stackTrace) {
      talker.handle(error, stackTrace, 'Failed to stop audio');
    }
  }

  /// Releases the native player if one has been created.
  Future<void> dispose() async {
    final player = _player;
    _player = null;
    if (player == null) return;

    try {
      await player.dispose();
    } catch (error, stackTrace) {
      talker.handle(error, stackTrace, 'Failed to dispose audio player');
    }
  }
}
