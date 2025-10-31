import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../AudioBackground/Audioplayerprovider.dart';
import 'AudioPlayerPage.dart';
import 'Miniplayer.dart';

class MainScreen extends StatelessWidget {
  final Widget child;

  const MainScreen({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AudioPlayerProvider>(
        builder: (context, audioPlayerProvider, _) {
          final showMiniPlayer = audioPlayerProvider.isMiniPlayerVisible;
          return Stack(
            children: [
              // Main content with padding if mini player is visible
              Padding(
                padding: EdgeInsets.only(
                  bottom: showMiniPlayer ? 70.0 : 0.0, // leave space for mini player
                ),
                child: child,
              ),

              // Mini Player overlay
              if (showMiniPlayer)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AudioPlayerPage(
                            audioUrl: audioPlayerProvider.songURL,
                            id: audioPlayerProvider.songId,
                            thumblineimg: audioPlayerProvider.imageUrl,
                          ),
                        ),
                      );
                    },
                    child: MiniPlayer(
                      player: audioPlayerProvider.audioPlayer,
                      songName: audioPlayerProvider.songName,
                      imageUrl: audioPlayerProvider.imageUrl,
                      onClose: audioPlayerProvider.hideMiniPlayer,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
