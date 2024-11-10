import 'dart:async';
import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:thiruvasagam/UI/AudioBackground/AudioplayerSingleton.dart';
import 'package:thiruvasagam/UI/AudioBackground/Audioplayerprovider.dart';
import 'package:thiruvasagam/model/modelclass.dart';
import 'package:lottie/lottie.dart';

class AudioPlayerPage extends StatefulWidget {
  final String audioUrl;
  final int id;
  final String thumblineimg;

  const AudioPlayerPage({
    Key? key,
    required this.audioUrl,
    required this.id,
    required this.thumblineimg,
  }) : super(key: key);

  @override
  State<AudioPlayerPage> createState() => _AudioPlayerPageState();
}

class _AudioPlayerPageState extends State<AudioPlayerPage> with WidgetsBindingObserver {
  late final AudioPlayerSingleton audioPlayerSingleton = AudioPlayerSingleton();
  List<Location> locations = [];
  String image = '';
  String name = '';
  bool offlineaudio = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeAudio();
    loadJsonData();
  }

  Future<void> _initializeAudio() async {
    if (await _checkInternetConnection()) {
      offlineaudio = true;
      await audioPlayerSingleton.init(widget.audioUrl, locations, widget.id);
      await audioPlayerSingleton.player.resume();
      setState(() {
        image = locations[audioPlayerSingleton.currentId].thumbnailimg;
        name = locations[audioPlayerSingleton.currentId].name;
      });
    } else {
      _showToast('No internet connection');
    }
  }

  Future<bool> _checkInternetConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
  }

  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.grey,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  Future<void> loadJsonData() async {
    String data = await rootBundle.loadString('assets/locations.json');
    List<dynamic> jsonList = json.decode(data);

    if (jsonList.isNotEmpty) {
      setState(() {
        locations = jsonList.map((json) => Location.fromJson(json)).toList();
        AudioPlayerSingleton().init(widget.audioUrl, locations, widget.id); // Initialize player

        image = locations[AudioPlayerSingleton().currentId].thumbnailimg;
        name = locations[AudioPlayerSingleton().currentId].name;
      });
    }
  }


  @override
  void dispose() {
    audioPlayerSingleton.dispose(); // Dispose the player on widget dispose
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final currentLocation = locations[audioPlayerSingleton.currentId];

        Provider.of<AudioPlayerProvider>(context, listen: false)
            .playSong(
          //widget.audioUrl,                // Use the current audio URL
          currentLocation.name,            // Dynamically pass the song name
          currentLocation.thumbnailimg,    // Dynamically pass the image URL
          //Duration(minutes: 3, seconds: 45),  // You can dynamically set the duration if available
        );
        Provider.of<AudioPlayerProvider>(context, listen: false).showMiniPlayer();
        return true;
      },
      child: Scaffold(
        body: Stack(
          children: [
            PlayerWidget(
              name: name,
              thumblineimg: image,
              player: audioPlayerSingleton.player,
              onFastForward: audioPlayerSingleton.moveToNextAudio,
              onRewind: audioPlayerSingleton.moveToPreviousAudio,
              offlineaudio: offlineaudio,
              isFirstAudio: audioPlayerSingleton.currentId == 0,
              isLastAudio: audioPlayerSingleton.currentId == locations.length - 1,
            ),
          ],
        ),
      ),
    );
  }

}


// MiniPlayer widget to display at the bottom when minimized
class MiniPlayer1 extends StatelessWidget {
  final AudioPlayer player;
  final String name;
  final String image;
  final VoidCallback onClose;

  const MiniPlayer1({
    Key? key,
    required this.player,
    required this.name,
    required this.image,
    required this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueGrey[800],
      height: 70,
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          image.isNotEmpty
              ? Image.network(
            image,
            height: 50,
            width: 50,
            fit: BoxFit.cover,
          )
              : const Icon(Icons.music_note, size: 50),
          const SizedBox(width: 10),
          // Song name
          Expanded(
            child: Text(
              name,
              style: const TextStyle(color: Colors.white, fontSize: 16),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // Play/pause button
          IconButton(
            icon: player.state == PlayerState.playing
                ? const Icon(Icons.pause, color: Colors.white)
                : const Icon(Icons.play_arrow, color: Colors.white),
            onPressed: () {
              if (player.state == PlayerState.playing) {
                player.pause();
              } else {
                player.resume();
              }
            },
          ),
          // Close button
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: onClose,
          ),
        ],
      ),
    );
  }
}



class PlayerWidget extends StatefulWidget {
  final AudioPlayer player;
  bool isFirstAudio;
  bool isLastAudio;
  final Function onRewind;
  final Function onFastForward;
  String name;
  String? thumblineimg;
  final bool offlineaudio;

   PlayerWidget({
    Key? key,
    required this.player,
    required this.isFirstAudio,
    required this.isLastAudio,
    required this.onRewind,
    required this.onFastForward,
    required this.name,
    this.thumblineimg,
    this.offlineaudio = false,
  }) : super(key: key);

  @override
  _PlayerWidgetState createState() => _PlayerWidgetState();
}

class _PlayerWidgetState extends State<PlayerWidget> with SingleTickerProviderStateMixin {
  PlayerState? _playerState;
  Duration? _duration;
  Duration? _position;
  final audioPlayerSingleton = AudioPlayerSingleton();

  StreamSubscription? _durationSubscription;
  StreamSubscription? _positionSubscription;
  StreamSubscription? _playerCompleteSubscription;
  StreamSubscription? _playerStateChangeSubscription;

  bool get _isPlaying => _playerState == PlayerState.playing;

  bool get _isPaused => _playerState == PlayerState.paused;

  String get _durationText => _duration?.toString().split('.').first ?? '';

  String get _positionText => _position?.toString().split('.').first ?? '';

  AudioPlayer get player => widget.player;
  double _volume = 0.5;
  late AnimationController _controller;

  String get _remainingTimeText {
    if (_duration != null && _position != null) {
      final remaining = _duration! - _position!;
      return remaining.toString().split('.').first;
    }
    return '';
  }

  @override
  void initState() {
    super.initState();
    _playerState = player.state;
    player.getDuration().then((value) => setState(() => _duration = value));
    player.getCurrentPosition().then((value) => setState(() => _position = value));
    _initStreams();
    player.setVolume(_volume);
    print('widget.thumblineimg${widget.thumblineimg}');
    _controller = AnimationController(vsync: this);
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.repeat();
      }
    });
    // Start playing initially
    _play();
  }

  void _setVolume(double value) {
    setState(() {
      _volume = value;
    });
    player.setVolume(value);
  }

  void _updateAudioDetails() {
    setState(() {
      widget.thumblineimg = audioPlayerSingleton.locations[audioPlayerSingleton.currentId].thumbnailimg;
      widget.name = audioPlayerSingleton.locations[audioPlayerSingleton.currentId].name;
    });
  }

  Future<void> handleRewind() {
    return audioPlayerSingleton.moveToPreviousAudio().then((details) {
      // Update image and name after rewinding
      _updateAudioDetails();
      widget.onRewind(); // Call the onRewind callback
    });
  }

  Future<void> handleNext() {
    return audioPlayerSingleton.moveToNextAudio().then((details) {
      // Update image and name after moving to next audio
      _updateAudioDetails();
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double width = constraints.maxWidth;
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
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.arrow_back),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          widget.name,
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                              fontFamily: 'MeeraInimai-Regular'),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    widget.name, // Updated name from the current audio
                    style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'MeeraInimai-Regular'),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.28,
                  width: MediaQuery.of(context).size.width * 1.0,
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: widget.thumblineimg != null && widget.thumblineimg!.isNotEmpty
                        ? Image.network(
                      widget.thumblineimg!, // Updated image from the current audio
                      fit: BoxFit.cover,
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) {
                          return child; // Return the image if loadingProgress is null
                        } else {
                          return const Center(
                              child: CircularProgressIndicator(
                                color: Colors.blue,
                              )); // Return CircularProgressIndicator while the image is loading
                        }
                      },
                    )
                        : const SizedBox(),
                  ),
                ),

                Slider(
                  onChanged: (value) {
                    final duration = _duration;
                    if (duration == null) {
                      return;
                    }
                    final position = value * duration.inMilliseconds;
                    player.seek(Duration(milliseconds: position.round()));
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
                  padding: EdgeInsets.only(left: 15, right: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _position != null
                            ? '$_positionText'
                            : _duration != null
                            ? _durationText
                            : '',
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        _position != null
                            ? '- $_remainingTimeText'
                            : _duration != null
                            ? _durationText
                            : '',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.height * 0.25,
                  child: FittedBox(
                    fit: BoxFit.fill,
                    child: Lottie.asset(
                      'assets/AnimationViewtest.json',
                      controller: _controller,
                      onLoaded: (composition) {
                        // Configure the AnimationController with the duration of the Lottie file
                        _controller.duration = composition.duration;
                      },
                    ),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      key: const Key('rewind_button'),
                      onPressed: widget.isFirstAudio ? null : handleRewind,
                      iconSize: MediaQuery.of(context).size.width * 0.1,
                      icon: const Icon(
                        Icons.fast_rewind,
                        size: 40,
                      ),
                      color: widget.isFirstAudio ? Colors.grey : Colors.black,
                    ),
                    SizedBox(width: 15),
                    IconButton(
                      key: const Key('play_pause_button'),
                      onPressed: () {
                        if (_isPlaying) {
                          _pause();
                        } else {
                          _play();
                        }
                      },
                      iconSize: MediaQuery.of(context).size.width * 0.1,
                      icon: _isPlaying
                          ? const Icon(
                        Icons.pause,
                        size: 70,
                      )
                          : const Icon(
                        Icons.play_arrow,
                        size: 70,
                      ),
                      color: Colors.black,
                    ),
                    SizedBox(width: 15),
                    IconButton(
                      key: const Key('fast_forward_button'),
                      onPressed: widget.isLastAudio ? null : handleNext,
                      iconSize: MediaQuery.of(context).size.width * 0.1,
                      icon: const Icon(
                        Icons.fast_forward,
                        size: 40,
                      ),
                      color: widget.isLastAudio ? Colors.grey : Colors.black,
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Icon(
                        Icons.volume_up,
                        color: Colors.black,
                      ),
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
      },
    );
  }

  Future<void> _play() async {
    await player.resume();
    setState(() {
      _playerState = PlayerState.playing;
      _controller.forward(); // Start the animation
    });
  }

  Future<void> _pause() async {
    await player.pause();
    setState(() {
      _playerState = PlayerState.paused;
      _controller.stop(); // Stop the animation
    });
  }

/*  @override
  void dispose() {
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    _playerCompleteSubscription?.cancel();
    _playerStateChangeSubscription?.cancel();
    _controller.dispose();
    super.dispose();
  }*/

  /*void _initStreams() {
    _durationSubscription = player.onDurationChanged.listen((duration) {
      setState(() {
        _duration = duration;
      });
    });

    _positionSubscription = player.onPositionChanged.listen((position) {
      if(mounted){
        setState(() {
          _position = position;
        });
      }

    });

    _playerCompleteSubscription = player.onPlayerComplete.listen((event) {
      handleNext(); // Automatically move to next audio when current is complete
    });

    _playerStateChangeSubscription = player.onPlayerStateChanged.listen((state) {
      setState(() {
        _playerState = state;
      });
    });
  }*/

  @override
  void dispose() {
    // Cancel the subscriptions to avoid calling setState on a disposed widget
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    _playerCompleteSubscription?.cancel();
    _playerStateChangeSubscription?.cancel();

    // Ensure to call super.dispose to complete the disposal process
    super.dispose();
  }

  void _initStreams() {
    _durationSubscription = player.onDurationChanged.listen((duration) {
      if (mounted) {
        setState(() {
          _duration = duration;
        });
      }
    });

    _positionSubscription = player.onPositionChanged.listen((position) {
      if (mounted) {
        setState(() {
          _position = position;
        });
      }
    });

    _playerCompleteSubscription = player.onPlayerComplete.listen((event) {
      handleNext(); // Automatically move to next audio when current is complete
    });

    _playerStateChangeSubscription = player.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          _playerState = state;
        });
      }
    });
  }
}
