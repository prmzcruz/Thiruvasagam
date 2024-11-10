import 'package:flutter/material.dart';
import 'package:provider/provider.dart';  // Assuming you are using Provider for state management
import 'package:thiruvasagam/UI/AudioBackground/Audioplayerprovider.dart';
import 'package:thiruvasagam/UI/Miniplayer.dart';
// import 'audio_player_provider.dart';  // Import your AudioPlayerProvider here
// import 'mini_player.dart';  // Import your MiniPlayer widget here

class MainScreen extends StatelessWidget {
  final Widget child;

  const MainScreen({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // The main content of the screen
          child,
          // The Mini Player is conditionally shown at the bottom of the screen
          Consumer<AudioPlayerProvider>(
            builder: (context, audioPlayerProvider, child) {
              return audioPlayerProvider.isMiniPlayerVisible
                  ? Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: MiniPlayer(
                  player: audioPlayerProvider.audioPlayer,
                  songName: audioPlayerProvider.songName,  // Pass the dynamic song name
                  imageUrl: audioPlayerProvider.imageUrl,  // Pass the dynamic image URL
                  //songDuration: audioPlayerProvider.songDuration,  // Pass the dynamic song duration
                  onClose: audioPlayerProvider.hideMiniPlayer,
                ),
              )
                  : SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}

