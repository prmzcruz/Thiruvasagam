import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thiruvasagam/UI/AudioBackground/Audioplayerprovider.dart';
import 'package:thiruvasagam/UI/Dashboard.dart';
import 'package:thiruvasagam/UI/Miniplayer.dart';

class MainLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AudioPlayerProvider>(
      builder: (context, audioProvider, child) {
        return Scaffold(
          body: Stack(
            children: [
              Navigator(
                onGenerateRoute: (settings) => MaterialPageRoute(
                  builder: (context) => const Dashboard(), // Your main page
                ),
              ),
              if (audioProvider.isMiniPlayerVisible)
                Align(
                  alignment: Alignment.bottomCenter,
                  /*child: MiniPlayer(
                    player: audioProvider.audioPlayer,
                    onClose: () => audioProvider.closeMiniPlayer(),
                  ),*/
                ),
            ],
          ),
        );
      },
    );
  }
}

