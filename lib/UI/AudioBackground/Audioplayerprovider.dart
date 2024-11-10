import 'package:audio_service/audio_service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thiruvasagam/UI/AudioBackground/Audiohandler.dart';

class AudioPlayerProvider extends ChangeNotifier {
  bool _isMiniPlayerVisible = false;
  AudioPlayer _audioPlayer = AudioPlayer();

  String _songName = '';
  String _imageUrl = '';
  Duration _songDuration = Duration.zero;

  bool get isMiniPlayerVisible => _isMiniPlayerVisible;
  AudioPlayer get audioPlayer => _audioPlayer;
  String get songName => _songName;
  String get imageUrl => _imageUrl;
  Duration get songDuration => _songDuration;

  void showMiniPlayer() {
    _isMiniPlayerVisible = true;
    notifyListeners();
  }

  void hideMiniPlayer() {
    _isMiniPlayerVisible = false;
    _audioPlayer.stop();  // Stop audio when the mini player is closed
    notifyListeners();
  }

  void togglePlayPause() async {
    print('togglePlayPause');
    print(_audioPlayer.state);
    if (_audioPlayer.state == PlayerState.playing) {
      print('song was playing');
      await _audioPlayer.pause();
    } else {
      print(_audioPlayer.state);
      await _audioPlayer.resume();
    }
    notifyListeners();  // Ensure the UI updates to reflect the current state
  }

  Future<void> playSong( String songName, String imageUrl) async { //Duration duration
    _songName = songName;
    _imageUrl = imageUrl;

    //await _audioPlayer.setSource(UrlSource(url));
   // _audioPlayer.resume(); // Use resume() instead of play(url)
    notifyListeners();
  }

  void closeMiniPlayer() {
    hideMiniPlayer();  // This will stop the player and hide the mini player
  }

  void disposePlayer() {
    _audioPlayer.dispose();
  }
}


