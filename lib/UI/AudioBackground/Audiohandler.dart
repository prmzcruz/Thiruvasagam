import 'package:audio_service/audio_service.dart';
import 'package:audioplayers/audioplayers.dart';

class MyAudioHandler extends BaseAudioHandler {
  final AudioPlayer _audioPlayer = AudioPlayer();

  MyAudioHandler() {
    _audioPlayer.onPlayerStateChanged.listen((state) {
      playbackState.add(playbackStateFor(state));
    });
  }

  @override
  Future<void> play() async {
    // Now just play the audio that was set earlier
    await _audioPlayer.resume();
  }

  // Pause audio
  Future<void> pause() async {
    await _audioPlayer.pause();
  }

  Future<void> stop() async {
    await _audioPlayer.stop();
  }

  // Fast forward or rewind
  Future<void> seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  // Get the current playback state from AudioPlayer's state
  PlaybackState playbackStateFor(PlayerState state) {
    if (state == PlayerState.playing) {
      return PlaybackState(
        playing: true,
        processingState: AudioProcessingState.ready,
      );
    } else if (state == PlayerState.paused) {
      return PlaybackState(
        playing: false,
        processingState: AudioProcessingState.ready,
      );
    } else {
      return PlaybackState(
        playing: false,
        processingState: AudioProcessingState.idle,
      );
    }
  }
}
