// import 'package:flutter_foreground_task/flutter_foreground_task.dart';
// import 'package:audioplayers/audioplayers.dart';
//
// class BackgroundAudioService {
//   static final AudioPlayer _audioPlayer = AudioPlayer();
//
//   static Future<void> initialize() async {
//     return FlutterForegroundTask.init(
//       androidNotificationOptions: AndroidNotificationOptions(
//         channelId: 'foreground_audio',
//         channelName: 'Audio Playback',
//         channelDescription: 'Audio playback in background',
//         iconData: const NotificationIconData(
//           resType: ResourceType.mipmap,
//           resPrefix: ResourcePrefix.img,
//           name: 'ic_launcher',
//         ),
//         playSound: false,
//         enableVibration: false,
//       ),
//       foregroundTaskOptions: const ForegroundTaskOptions(
//         isOnceEvent: false,
//         autoRunOnBoot: false,
//         allowWakeLock: true,
//         allowWifiLock: true,
//       ),
//       iosNotificationOptions: const IOSNotificationOptions(), // ✅ FIXED: Use an empty object instead of `null`
//     );
//   }
//
//   // Start background audio service
//   static Future<void> startService() async {
//     await initialize(); // Ensure initialization is done before starting
//     await FlutterForegroundTask.startService(
//       notificationTitle: 'Playing Audio',
//       notificationText: 'Your song is playing in the background',
//     );
//     await _audioPlayer.play(UrlSource("https://ishapoultryengineering.com/audio/sivapuranam.mp3"));
//   }
//
//   // Stop background audio service
//   static Future<void> stopAudio() async {
//     await _audioPlayer.stop();
//     await FlutterForegroundTask.stopService();
//   }
// }
