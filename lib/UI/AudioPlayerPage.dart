import 'dart:async';
import 'dart:convert';

import 'package:audio_service/audio_service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:thiruvasagam/model/modelclass.dart';
import 'package:lottie/lottie.dart';

class AudioPlayerPage extends StatefulWidget {
  final String audioUrl;
  final int id;
  final String thumblineimg;

  const AudioPlayerPage(
      {Key? key,
        required this.audioUrl,
        required this.id,
        required this.thumblineimg})
      : super(key: key);

  @override
  State<AudioPlayerPage> createState() => _AudioPlayerPageState();
}

class _AudioPlayerPageState extends State<AudioPlayerPage> {
  late AudioPlayer player = AudioPlayer();
  List<Location> locations = [];
  List<String> locationNames = [];
  int currentId = 0;
  String image = '';
  String name = '';
  bool offlineaudio = false;
  late AudioHandler _audioHandler;

  @override
  void initState() {
    super.initState();
    player = AudioPlayer();
    player.setReleaseMode(ReleaseMode.stop);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (await _checkInternetConnection()) {
        offlineaudio = true;
        await player.setSourceUrl(widget.audioUrl);
        await player.resume();
      } else {
        _showToast('No internet connection');
        print('new change');
      }
    });
    loadJsonData();
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
        locationNames = locations.map((location) => location.name).toList();
        currentId =
            locations.indexWhere((location) => location.id == widget.id);
        image = locations[currentId].thumbnailimg;
        name = locations[currentId].name;
      });
    }
  }

  Future<void> moveToNextAudio() async {
    if (currentId < locations.length - 1) {

      setState(() {
        currentId++;
        image = locations[currentId].thumbnailimg; // Update thumbnail image
        name = locations[currentId].name;
      });
      try{

        await player.setSourceUrl(locations[currentId].audioUrl);
        // if(player.state != PlayerState.playing && player.state != PlayerState.completed){
        //
        // }
        await player.resume();

      }catch(e){
        print('Error setting audio source: $e');
      }

    }
  }

  Future<void> moveToPreviousAudio() async {
    if (currentId > 0) {
      setState(() {
        currentId--;
        image = locations[currentId].thumbnailimg; // Update thumbnail image
        name = locations[currentId].name;
      });
      await player.setSourceUrl(locations[currentId].audioUrl);
      await player.resume();
    }
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
        centerTitle: false,
        leadingWidth: 25,
        title: Text(name,style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.blue,fontFamily: 'MeeraInimai-Regular'),),
      ),*/
      body: PlayerWidget(
        name: name,
        thumblineimg: image,
        player: player,
        onFastForward: moveToNextAudio,
        onRewind: moveToPreviousAudio, offlineaudio:offlineaudio,isFirstAudio: currentId == 0,isLastAudio: currentId == locations.length - 1,),
    );
  }
}



class PlayerWidget extends StatefulWidget {
  final AudioPlayer player;
  final bool isFirstAudio;
  final bool isLastAudio;
  final Function onRewind;
  final Function onFastForward;
  final String name;
  final String? thumblineimg;
  final bool offlineaudio;

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
  }) : super(key: key);

  @override
  _PlayerWidgetState createState() => _PlayerWidgetState();
}

class _PlayerWidgetState extends State<PlayerWidget> with SingleTickerProviderStateMixin {
  PlayerState? _playerState;
  Duration? _duration;
  Duration? _position;

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

  @override
  void dispose() {
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    _playerCompleteSubscription?.cancel();
    _playerStateChangeSubscription?.cancel();
    _controller.dispose();
    player.dispose();
    super.dispose();
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
                    widget.name,
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
                        ? widget.offlineaudio
                        ? Image.network(
                      widget.thumblineimg!,
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
                        : SizedBox()
                        : SizedBox(),
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
                      onPressed: widget.isFirstAudio ? null : widget.onRewind as void Function()?,
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
                      onPressed: widget.isLastAudio ? null : widget.onFastForward as void Function()?,
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
                        Icons.volume_mute,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    Expanded(
                      child: Slider(
                        value: _volume,
                        min: 0.0,
                        max: 1.0,
                        onChanged: _setVolume,
                        activeColor: Colors.blueAccent,
                        inactiveColor: Colors.grey,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: Icon(
                        Icons.volume_up_sharp,
                        color: Colors.white,
                        size: 30,
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

  void _initStreams() {
    _durationSubscription = player.onDurationChanged.listen((duration) {
      setState(() => _duration = duration);
    });

    _positionSubscription =
        player.onPositionChanged.listen((p) => setState(() => _position = p));

    _playerCompleteSubscription = player.onPlayerComplete.listen((event) {
      setState(() {
        _playerState = PlayerState.stopped;
        print('song complete');
        setState(() {
          widget.onFastForward();
        });
      });
    });

    _playerStateChangeSubscription = player.onPlayerStateChanged.listen((state) {
      setState(() {
        _playerState = state;
      });
    });
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
}


