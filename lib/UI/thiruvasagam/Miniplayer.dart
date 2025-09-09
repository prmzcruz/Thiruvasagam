import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:provider/provider.dart';
import 'package:thiruvasagam/UI/AudioBackground/Audioplayerprovider.dart';
import 'package:thiruvasagam/utility/color.dart';
import 'package:thiruvasagam/utility/utility.dart';

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
    final audioPlayerProvider = Provider.of<AudioPlayerProvider>(context);
    return Container(
      color: HexColor(Colorscommon.red),
      height: 70,
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              imageUrl.isNotEmpty ? imageUrl : 'https://via.placeholder.com/50',
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => const Icon(Icons.music_note, size: 50, color: Colors.white),
            ),
          ),
          const SizedBox(width: 10),
          // Use Flexible to prevent overflow
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    songName,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                // Optional duration text
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: audioPlayerProvider.playerState == PlayerState.playing
                    ? const Icon(Icons.pause, color: Colors.white)
                    : const Icon(Icons.play_arrow, color: Colors.white),
                onPressed: () {
                  if (audioPlayerProvider.playerState == PlayerState.playing) {
                    audioPlayerProvider.pausePlayer();
                  } else {
                    audioPlayerProvider.playPlayer();
                  }
                },
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: onClose,
              ),
            ],
          ),
        ],
      ),
    );

  }
}
