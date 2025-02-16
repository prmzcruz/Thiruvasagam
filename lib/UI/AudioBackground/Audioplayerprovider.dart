import 'package:audio_service/audio_service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thiruvasagam/UI/AudioBackground/Audiohandler.dart';
import 'package:thiruvasagam/UI/AudioBackground/AudioplayerSingleton.dart';

class AudioPlayerProvider extends ChangeNotifier {
  bool _isMiniPlayerVisible = false;
  AudioPlayer _audioPlayer = AudioPlayer();
  final AudioPlayerSingleton _audioPlayerSingleton = AudioPlayerSingleton();

  String _songName = '';
  String _imageUrl = '';
  Duration _songDuration = Duration.zero;

  bool get isMiniPlayerVisible => _isMiniPlayerVisible;
  AudioPlayer get audioPlayer => _audioPlayer;
  String get songName => _audioPlayerSingleton.locations.isNotEmpty
      ? _audioPlayerSingleton.locations[_audioPlayerSingleton.currentId].name
      : '';
  String get imageUrl => _audioPlayerSingleton.locations.isNotEmpty
      ? _audioPlayerSingleton.locations[_audioPlayerSingleton.currentId].thumbnailimg
      : '';
  Duration get songDuration => _songDuration;
  PlayerState get playerState => _audioPlayerSingleton.player.state;



  AudioPlayerProvider() {
    // Listen to player state changes
    _audioPlayer.onPlayerStateChanged.listen((state) {
      notifyListeners();
    });
  }

  void showMiniPlayer() {
    _isMiniPlayerVisible = true;
    notifyListeners();
  }

  Future<void> pausePlayer() async {
    if (_audioPlayerSingleton.player.state == PlayerState.playing) {
      await _audioPlayerSingleton.player.pause();
      notifyListeners();
    }
  }

  Future<void> playPlayer() async {
    if (_audioPlayerSingleton.player.state != PlayerState.playing) {
      await _audioPlayerSingleton.player.resume();
      notifyListeners();
    }
  }

  void hideMiniPlayer() {
    _isMiniPlayerVisible = false;
    _audioPlayerSingleton.player.stop();
    notifyListeners();
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

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}


