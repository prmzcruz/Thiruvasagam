import 'dart:async';
import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
//import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:thiruvasagam/UI/AudioBackground/AudioplayerSingleton.dart';
import 'package:thiruvasagam/UI/AudioBackground/Audioplayerprovider.dart';
import 'package:thiruvasagam/model/lyrics.dart';
import 'package:thiruvasagam/model/thiruvasagam_modelclass.dart';

class AudioPlayerPagesample extends StatefulWidget {
  final String audioUrl;
  final int id;
  final String thumblineimg;

  const AudioPlayerPagesample({
    Key? key,
    required this.audioUrl,
    required this.id,
    required this.thumblineimg,
  }) : super(key: key);

  @override
  State<AudioPlayerPagesample> createState() => _AudioPlayerPagesampleState();
}

class _AudioPlayerPagesampleState extends State<AudioPlayerPagesample> with WidgetsBindingObserver {
  late final AudioPlayerSingleton audioPlayerSingleton = AudioPlayerSingleton();
  List<Location> locations = [];
  bool offlineaudio = false;
  List<LyricLine> allLyrics = [];
  List<LyricLine> allLyrics1 = [];
  StreamSubscription? _songChangeSubscription;
  Map<int, List<LyricLine>> lyricsMap = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeAudio();
    loadJsonData();
    lyricsJsonData();
    //_setupSongChangeListener();
  }

  Future<void> _initializeAudio() async {
   // if (await _checkInternetConnection()) {
      offlineaudio = true;
      await audioPlayerSingleton.init(widget.audioUrl, locations, widget.id);
      await audioPlayerSingleton.player.resume();
    // } else {
    //   ('No internet connection');
    //   Fluttertoast.showToast(
    //     msg: 'No internet connection',
    //     backgroundColor: Colors.red,
    //     gravity: ToastGravity.BOTTOM,
    //   );
    // }
  }

  // Future<bool> _checkInternetConnection() async {
  //   var connectivityResult = await (Connectivity().checkConnectivity());
  //   return connectivityResult != ConnectivityResult.none;
  // }

  Future<void> loadJsonData() async {
    String data = await rootBundle.loadString('assets/locations.json');
    List<dynamic> jsonList = json.decode(data);

    if (jsonList.isNotEmpty) {
      setState(() {
        locations = jsonList.map((json) => Location.fromJson(json)).toList();
        audioPlayerSingleton.init(widget.audioUrl, locations, widget.id);
      });
    }
  }

  Future<void> lyricsJsonData() async {
    String data = await rootBundle.loadString('assets/Lyrics.json');
    Map<String, dynamic> jsonData = json.decode(data);

    setState(() {
      lyricsMap.clear();
      jsonData.forEach((key, value) {
        int id = int.tryParse(key) ?? 0;
        if (value is List) {
          lyricsMap[id] = value.map((e) => LyricLine.fromJson(e)).toList();
        } else {
          debugPrint("Skipping id $id because value is not a List: $value");
        }
      });
    });
  }


  // void _setupSongChangeListener() {
  //   _songChangeSubscription = audioPlayerSingleton.onSongChanged.listen((_) {
  //     if (mounted) {
  //       setState(() {});
  //     }
  //   });
  // }

  Future <void>_showMiniPlayer() async{
    final currentLocation = locations[audioPlayerSingleton.currentId];
    Provider.of<AudioPlayerProvider>(context, listen: false).playSong(
      currentLocation.name,
      currentLocation.thumbnailimg,
    );
    Provider.of<AudioPlayerProvider>(context, listen: false).showMiniPlayer();
  }

  @override
  void dispose() {
    _songChangeSubscription?.cancel();
    audioPlayerSingleton.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    if (locations.isEmpty) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (audioPlayerSingleton.currentId < 0 ||
        audioPlayerSingleton.currentId >= locations.length) {
      return Scaffold(
        body: Center(
          child: Text("Invalid audio track"),
        ),
      );
    }

    final currentLocation = locations[audioPlayerSingleton.currentId];
    List<LyricLine> lyricsToDisplay = lyricsMap[currentLocation.id] ?? [];
    return WillPopScope(
      onWillPop: () async {
        _showMiniPlayer();
        return true;
      },
      child: Scaffold(
        body: Stack(
          children: [
            PlayerWidget(
              name: currentLocation.name,
              thumblineimg: currentLocation.thumbnailimg,
              player: audioPlayerSingleton.player,
              onFastForward: audioPlayerSingleton.moveToNextAudio,
              onRewind: audioPlayerSingleton.moveToPreviousAudio,
              offlineaudio: offlineaudio,
              isFirstAudio: audioPlayerSingleton.currentId == 0,
              isLastAudio: audioPlayerSingleton.currentId == locations.length - 1,
              miniPlayer: _showMiniPlayer,
              lyrics: lyricsToDisplay,
            ),
          ],
        ),
      ),
    );
  }
}
class PlayerWidget extends StatefulWidget {
  final AudioPlayer player;
  final bool isFirstAudio;
  final bool isLastAudio;
  final VoidCallback onRewind; // Changed from Function to VoidCallback
  final VoidCallback onFastForward;
  final String name;
  final String? thumblineimg;
  final bool offlineaudio;
  final Future<void> Function() miniPlayer;
  final List<LyricLine> lyrics;

  const PlayerWidget({
    Key? key,
    required this.player,
    required this.isFirstAudio,
    required this.isLastAudio,
    required this.onRewind,
    required this.onFastForward,
    required this.name,
    this.thumblineimg,
    this.offlineaudio = false,
    required this.miniPlayer,
    required this.lyrics,
  }) : super(key: key);

  @override
  _PlayerWidgetState createState() => _PlayerWidgetState();
}

class _PlayerWidgetState extends State<PlayerWidget> {
  PlayerState? _playerState;
  Duration? _duration;
  Duration? _position;
  double _volume = 0.5;
  int _currentLyricIndex = -1;
  final ScrollController _scrollController = ScrollController();

  StreamSubscription? _durationSubscription;
  StreamSubscription? _positionSubscription;
  StreamSubscription? _playerCompleteSubscription;
  StreamSubscription? _playerStateChangeSubscription;

  bool get _isPlaying => _playerState == PlayerState.playing;
  bool get _isPaused => _playerState == PlayerState.paused;
  String get _durationText => _duration?.toString().split('.').first ?? '';
  String get _positionText => _position?.toString().split('.').first ?? '';

  @override
  void initState() {
    super.initState();
    _playerState = widget.player.state;
    widget.player.getDuration().then((value) => setState(() => _duration = value));
    widget.player.getCurrentPosition().then((value) => setState(() => _position = value));
    _initStreams();
    widget.player.setVolume(_volume);
  }

  @override
  void dispose() {
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    _playerCompleteSubscription?.cancel();
    _playerStateChangeSubscription?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  void _initStreams() {
    _durationSubscription = widget.player.onDurationChanged.listen((duration) {
      if (mounted) {
        setState(() => _duration = duration);
      }
    });

    _positionSubscription = widget.player.onPositionChanged.listen((position) {
      if (mounted) {
        setState(() => _position = position);
        _updateLyricHighlight(position);
      }
    });

    _playerCompleteSubscription = widget.player.onPlayerComplete.listen((event) {
      if (!widget.isLastAudio) {
        widget.onFastForward();
      }
    });

    _playerStateChangeSubscription = widget.player.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() => _playerState = state);
      }
    });
  }

  Duration _parseTimestamp(String timestamp) {
    try {
      final parts = timestamp.split(':');
      if (parts.length == 3) {
        return Duration(
          hours: int.parse(parts[0]),
          minutes: int.parse(parts[1]),
          seconds: int.parse(parts[2]),
        );
      } else if (parts.length == 2) {
        return Duration(
          minutes: int.parse(parts[0]),
          seconds: int.parse(parts[1]),
        );
      }
      return Duration.zero;
    } catch (e) {
      return Duration.zero;
    }
  }

  void _updateLyricHighlight(Duration position) {
    if (widget.lyrics.isEmpty) return;

    int newIndex = -1;
    for (int i = 0; i < widget.lyrics.length; i++) {
      final lyricTime = _parseTimestamp(widget.lyrics[i].timestamp);
      if (position >= lyricTime) {
        newIndex = i;
      } else {
        break;
      }
    }

    if (newIndex != _currentLyricIndex) {
      setState(() => _currentLyricIndex = newIndex);

      if (newIndex >= 0) {
        _scrollController.animateTo(
          (newIndex * 30.0).clamp(0.0, _scrollController.position.maxScrollExtent),
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    }
  }


  void _setVolume(double value) {
    if (mounted) {
      setState(() => _volume = value);
    }
    widget.player.setVolume(value);
  }

  Future<void> _play() async {
    await widget.player.resume();
    setState(() => _playerState = PlayerState.playing);
  }

  Future<void> _pause() async {
    await widget.player.pause();
    setState(() => _playerState = PlayerState.paused);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 1.0,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.centerRight,
          colors: [
            Colors.white,
            Colors.red,
            Colors.indigo,
          ],
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      widget.miniPlayer();
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back),
                  ),
                  Expanded(
                    child: Text(
                      widget.name,
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                          fontFamily: 'MeeraInimai-Regular'
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Text(
                widget.name,
                style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'MeeraInimai-Regular'
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.28,
              width: MediaQuery.of(context).size.width * 1.0,
              padding: EdgeInsets.all(15),
              child: widget.thumblineimg != null && widget.thumblineimg!.isNotEmpty
                  ? Image.network(
                widget.thumblineimg!,
                fit: BoxFit.cover,
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  } else {
                    return const Center(
                        child: CircularProgressIndicator(color: Colors.blue));
                  }
                },
              )
                  : const SizedBox(),
            ),
            Slider(
              onChanged: (value) {
                if (_duration == null) return;
                final position = value * _duration!.inMilliseconds;
                widget.player.seek(Duration(milliseconds: position.round()));
              },
              value: (_position != null &&
                  _duration != null &&
                  _position!.inMilliseconds > 0 &&
                  _position!.inMilliseconds < _duration!.inMilliseconds)
                  ? _position!.inMilliseconds / _duration!.inMilliseconds
                  : 0.0,
              activeColor: Colors.blueAccent,
              inactiveColor: Colors.grey,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_positionText, style: TextStyle(color: Colors.white)),
                  Text(
                      _duration != null
                          ? '-${(_duration! - (_position ?? Duration.zero)).toString().split('.').first}'
                          : '',
                      style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
            // Lyrics Display
            Container(
              height: MediaQuery.of(context).size.height * 0.25,
              margin: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(10),
              ),
              child: widget.lyrics.isEmpty
                  ? Center(
                child: Text(
                  "No lyrics available",
                  style: TextStyle(color: Colors.white70),
                ),
              )
                  : ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(8),
                itemCount: widget.lyrics.length,
                itemBuilder: (context, index) {
                  final lyric = widget.lyrics[index];
                  bool isActive = index == _currentLyricIndex;
                  bool isPast = index < _currentLyricIndex;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                    child: Text(
                      lyric.line,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: isActive ? 20 : 16,
                        fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                        color: isActive
                            ? Colors.red
                            : isPast
                            ? Colors.white70
                            : Colors.white,
                      ),
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: widget.isFirstAudio ? null : widget.onRewind,
                  iconSize: MediaQuery.of(context).size.width * 0.1,
                  icon: Icon(Icons.fast_rewind, size: 40),
                  color: widget.isFirstAudio ? Colors.grey : Colors.black,
                ),
                SizedBox(width: 15),
                IconButton(
                  onPressed: () => _isPlaying ? _pause() : _play(),
                  iconSize: MediaQuery.of(context).size.width * 0.1,
                  icon: _isPlaying
                      ? Icon(Icons.pause, size: 70)
                      : Icon(Icons.play_arrow, size: 70),
                  color: Colors.black,
                ),
                SizedBox(width: 15),
                IconButton(
                  onPressed: widget.isLastAudio ? null : widget.onFastForward,
                  iconSize: MediaQuery.of(context).size.width * 0.1,
                  icon: Icon(Icons.fast_forward, size: 40),
                  color: widget.isLastAudio ? Colors.grey : Colors.black,
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Icon(Icons.volume_up, color: Colors.black),
                ),
                Expanded(
                  child: Slider(
                    value: _volume,
                    min: 0,
                    max: 1,
                    divisions: 10,
                    activeColor: Colors.blueAccent,
                    inactiveColor: Colors.grey,
                    onChanged: _setVolume,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}