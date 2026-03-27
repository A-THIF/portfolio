import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class SoundEffects {
  static final AudioPlayer _bgPlayer = AudioPlayer();
  static final AudioPlayer _jumpPlayer = AudioPlayer();
  static final AudioPlayer _whoaPlayer = AudioPlayer();
  static final AudioPlayer _coinPlayer = AudioPlayer();

  static bool _hasPlayedOneUp = false;

  static bool get isMobileWeb =>
      kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.iOS ||
          defaultTargetPlatform == TargetPlatform.android);

  static Future<void> playJump() async {
    try {
      if (_jumpPlayer.state == PlayerState.playing) {
        await _jumpPlayer.stop();
      }
      await _jumpPlayer
          .play(AssetSource('audios/maro-jump-sound-effect_1.mp3'));
    } catch (e) {
      debugPrint("Error playing jump: $e");
    }
  }

  static Future<void> playWhoa() async {
    try {
      if (_whoaPlayer.state == PlayerState.playing) {
        await _whoaPlayer.stop();
      }
      await _whoaPlayer.play(AssetSource('audios/sm64_mario_whoa.mp3'));
    } catch (e) {
      debugPrint("Error playing whoa: $e");
    }
  }

  static Future<void> playCoin() async {
    try {
      if (_coinPlayer.state == PlayerState.playing) {
        await _coinPlayer.stop();
      }
      await _coinPlayer.play(AssetSource('audios/mario-coin-sound-effect.mp3'));
    } catch (e) {
      debugPrint("Error playing coin: $e");
    }
  }

  static Future<void> playOneUp() async {
    if (!_hasPlayedOneUp) {
      try {
        _hasPlayedOneUp = true;
        final player = AudioPlayer()..setReleaseMode(ReleaseMode.release);
        await player.play(AssetSource('audios/mario-1-up.mp3'));
        debugPrint("Surprise! 1-Up played.");
      } catch (e) {
        debugPrint("Error playing 1-up: $e");
      }
    }
  }

  static Future<void> playFireball() async {
    try {
      final player = AudioPlayer()..setReleaseMode(ReleaseMode.release);
      await player.play(AssetSource('audios/mario-fireball.mp3'));
    } catch (e) {
      debugPrint("Error playing fireball: $e");
    }
  }

  static Future<void> playSuperMarioBros() async {
    try {
      final player = AudioPlayer()..setReleaseMode(ReleaseMode.release);
      await player.play(AssetSource('audios/super-mario-bros.mp3'));
    } catch (e) {
      debugPrint("Error playing Super Mario Bros: $e");
    }
  }

  static Future<void> playOpening() async {
    try {
      await _bgPlayer.setReleaseMode(ReleaseMode.stop);
      await _bgPlayer.setSource(AssetSource('audios/mario-opening.mp3'));
      await _bgPlayer.play(AssetSource('audios/mario-opening.mp3'));
    } catch (e) {
      debugPrint("Error playing opening: $e");
    }
  }

  static void resetOneUp() {
    _hasPlayedOneUp = false;
  }
}
