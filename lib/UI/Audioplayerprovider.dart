import 'package:audio_service/audio_service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thiruvasagam/UI/Audiohandler.dart';

class AudioPlayerProvider extends ChangeNotifier {
  AudioPlayer _audioPlayer = AudioPlayer();
  bool _isMiniPlayerVisible = false;

  bool get isMiniPlayerVisible => _isMiniPlayerVisible;

  AudioPlayer get audioPlayer => _audioPlayer;

  void play(String url) async {
    await _audioPlayer.setSourceUrl(url);
    await _audioPlayer.resume();
    _isMiniPlayerVisible = true;
    notifyListeners();
  }

  void pause() {
    _audioPlayer.pause();
    notifyListeners();
  }

  void resume() {
    _audioPlayer.resume();
    notifyListeners();
  }

  void stop() {
    _audioPlayer.stop();
    _isMiniPlayerVisible = false;
    notifyListeners();
  }

  void closeMiniPlayer() {
    _isMiniPlayerVisible = false;
    notifyListeners();
  }
}

