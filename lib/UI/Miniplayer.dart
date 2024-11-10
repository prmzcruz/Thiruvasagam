import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:provider/provider.dart';
import 'package:thiruvasagam/UI/AudioBackground/Audioplayerprovider.dart';

class MiniPlayer extends StatelessWidget {
  final AudioPlayer player;
  final VoidCallback onClose;
  final String songName;
  final String imageUrl;
  //final Duration songDuration;

  const MiniPlayer({
    Key? key,
    required this.player,
    required this.onClose,
    required this.songName,
    required this.imageUrl,
    //required this.songDuration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueGrey[800],
      height: 70,
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          // Display album art or song thumbnail
          Image.network(
            imageUrl,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
          const SizedBox(width: 10),
          // Display song name and duration
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  songName,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                /*Text(
                  "${songDuration.inMinutes}:${(songDuration.inSeconds % 60).toString().padLeft(2, '0')}",
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),*/
              ],
            ),
          ),
          IconButton(
            icon: Provider.of<AudioPlayerProvider>(context).audioPlayer.state == PlayerState.playing
                ? const Icon(Icons.pause, color: Colors.white)
                : const Icon(Icons.play_arrow, color: Colors.white),
            onPressed: () {
              Provider.of<AudioPlayerProvider>(context, listen: false).togglePlayPause();
            },
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: onClose,
          ),
        ],
      ),
    );
  }
}
