import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thiruvasagam/UI/Audioplayerprovider.dart';

class MiniPlayer extends StatelessWidget {
  final AudioPlayer player;
  final VoidCallback onClose;

  const MiniPlayer({
    Key? key,
    required this.player,
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
          const Icon(Icons.music_note, size: 50),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              "Playing now",
              style: const TextStyle(color: Colors.white, fontSize: 16),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
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
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: onClose,
          ),
        ],
      ),
    );
  }
}

