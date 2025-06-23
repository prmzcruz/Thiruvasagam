import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class videopage extends StatefulWidget {
  final String videoId;
  final String name;
  final String thumblineimg;
  const videopage({Key? key, required this.videoId, required this.name,required this.thumblineimg}) : super(key: key);

  @override
  State<videopage> createState() => _videopageState();
}

class _videopageState extends State<videopage> {
  late YoutubePlayerController controller;

  @override
  void initState() {
    super.initState();
    controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.blue),
          centerTitle: false,
          leadingWidth: 25,
          title: Text(widget.name,style: const TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.blue),),
          backgroundColor: Colors.black,
        ),
        body: Center(
          child: YoutubePlayer(
            progressColors: const ProgressBarColors(
              backgroundColor: Colors.grey,
              playedColor: Colors.red,
              bufferedColor: Colors.red,
              handleColor: Colors.red,
            ),
            thumbnail: Image.network(widget.thumblineimg),
            progressIndicatorColor: Colors.red,
            controller: controller,
            showVideoProgressIndicator: true,
            onReady: () {
              print('Video is ready to play');
            },
          ),
        ),
      );
  }
}
