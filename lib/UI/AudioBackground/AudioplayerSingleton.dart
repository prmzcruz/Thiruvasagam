import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:thiruvasagam/model/modelclass.dart';

class AudioPlayerSingleton {
  static final AudioPlayerSingleton _instance = AudioPlayerSingleton._internal();
  factory AudioPlayerSingleton() => _instance;

  final AudioPlayer player;
  List<Location> locations = [];
  int currentId = 0;

  AudioPlayerSingleton._internal() : player = AudioPlayer();

  Future<void> init(String audioUrl, List<Location> locs, int id) async {
    locations = locs;
    currentId = id;
    await player.setSourceUrl(audioUrl);
  }

  Future<Map<String, String>> moveToNextAudio() async {
    if (currentId < locations.length - 1) {
      currentId++;
      await player.setSourceUrl(locations[currentId].audioUrl);
      await player.resume();

      // Return updated song name and image
      return {
        'name': locations[currentId].name,
        'image': locations[currentId].thumbnailimg,
      };
    }
    return {}; // Return empty map if there's no next audio
  }

  Future<Map<String, String>> moveToPreviousAudio() async {
    if (currentId > 0) {
      currentId--;
      await player.setSourceUrl(locations[currentId].audioUrl);
      await player.resume();

      // Return updated song name and image
      return {
        'name': locations[currentId].name,
        'image': locations[currentId].thumbnailimg,
      };
    }
    return {}; // Return empty map if there's no previous audio
  }

  void dispose() {
    player.dispose();
  }
}
