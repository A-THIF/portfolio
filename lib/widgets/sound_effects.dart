import 'package:audioplayers/audioplayers.dart';

class SoundEffects {
  static final AudioPlayer _player = AudioPlayer();

  // 🎮 Mario Jump (from local assets)
  static Future<void> playJump() async {
    try {
      await _player.stop();
      // AssetSource starts looking from the 'assets/' folder automatically
      await _player.play(AssetSource('audios/maro-jump-sound-effect_1.mp3'));
    } catch (e) {
      print("Error playing jump: $e");
    }
  }

  // 🎮 Mario Whoa (from local assets)
  static Future<void> playWhoa() async {
    try {
      await _player.stop();
      await _player.play(AssetSource('audios/sm64_mario_whoa.mp3'));
    } catch (e) {
      print("Error playing whoa: $e");
    }
  }
}
