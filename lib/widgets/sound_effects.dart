// C:\Users\parve\Documents\Projects\portfolio\lib\widgets\sound_effects.dart

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart'; // Added for debugPrint

class SoundEffects {
  static final AudioPlayer _player = AudioPlayer();
  static bool _hasPlayedOneUp = false; // To track if 1-up has been played

  static Future<void> playJump() async {
    try {
      await _player.stop();
      await _player.play(AssetSource('audios/maro-jump-sound-effect_1.mp3'));
    } catch (e) {
      debugPrint("Error playing jump: $e");
    }
  }

  static Future<void> playWhoa() async {
    try {
      await _player.stop();
      await _player.play(AssetSource('audios/sm64_mario_whoa.mp3'));
    } catch (e) {
      debugPrint("Error playing whoa: $e");
    }
  }

  // 🍄 New 1-Up Sound for Profile Switch
  static Future<void> playOneUp() async {
    // 2. Only run if it HAS NOT played yet
    if (!_hasPlayedOneUp) {
      try {
        _hasPlayedOneUp =
            true; // 3. Set to true immediately so it can't trigger again

        await _player.stop();
        // Remember: No 'assets/' prefix here
        await _player.play(AssetSource('audios/mario-1-up.mp3'));

        debugPrint("Surprise! 1-Up played for the first and only time.");
      } catch (e) {
        debugPrint("Error playing 1-up: $e");
      }
    }
  }

  // If you want to reset it (e.g., when the app restarts or a specific event happens)
  static void resetOneUp() {
    _hasPlayedOneUp = false;
  }
}
