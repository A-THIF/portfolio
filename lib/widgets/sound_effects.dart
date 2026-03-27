import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class SoundEffects {
  static bool _hasPlayedOneUp = false;

  // 🔥 CORE FIX: always create new player
  static Future<void> _play(String path) async {
    try {
      final player = AudioPlayer();

      await player.setReleaseMode(ReleaseMode.stop);
      await player.play(AssetSource(path));

      // 🔥 auto dispose after finish (important for mobile)
      player.onPlayerComplete.listen((_) {
        player.dispose();
      });
    } catch (e) {
      debugPrint("Audio error ($path): $e");
    }
  }

  static Future<void> playJump() async {
    await _play('audios/maro-jump-sound-effect_1.mp3');
  }

  static Future<void> playWhoa() async {
    await _play('audios/sm64_mario_whoa.mp3');
  }

  static Future<void> playCoin() async {
    await _play('audios/mario-coin-sound-effect.mp3');
  }

  static Future<void> playFireball() async {
    await _play('audios/mario-fireball.mp3');
  }

  static Future<void> playSuperMarioBros() async {
    await _play('audios/super-mario-bros.mp3');
  }

  static Future<void> playOpening() async {
    await _play('audios/mario-opening.mp3');
  }

  // 🍄 one-time sound
  static Future<void> playOneUp() async {
    if (_hasPlayedOneUp) return;

    _hasPlayedOneUp = true;
    await _play('audios/mario-1-up.mp3');
  }

  static void resetOneUp() {
    _hasPlayedOneUp = false;
  }
}
