import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:thiruvasagam/UI/AudioPlayerPage.dart';
import 'package:thiruvasagam/UI/AudioBackground/Audioplayerprovider.dart';
import 'package:thiruvasagam/UI/Dashboard.dart';
import 'package:thiruvasagam/UI/Miniplayer.dart';


Future<void> main() async{


  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.blue, // navigation bar color
    statusBarColor: Colors.white, // status bar color
  ));
  runApp(
    ChangeNotifierProvider(
      create: (context) => AudioPlayerProvider(),
      child: MyApp(),
    ),
  );

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        //colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        primaryColor: Colors.white,
        useMaterial3: true,
      ),
      home: Splashscreen(), // change this Splashscreen instead of MainLayout
    );
  }
}

class MainLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AudioPlayerProvider>(
      builder: (context, audioProvider, child) {
        return Scaffold(
          body: Stack(
            children: [
              Navigator( // Handles navigation
                onGenerateRoute: (settings) => MaterialPageRoute(
                  builder: (context) => const Dashboard(),
                ),
              ),
              // Mini Player
              if (audioProvider.isMiniPlayerVisible)
                Consumer<AudioPlayerProvider>(
                  builder: (context, audioPlayerProvider, child) {
                    return audioPlayerProvider.isMiniPlayerVisible
                        ? Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: MiniPlayer(
                        player: audioPlayerProvider.audioPlayer,
                        songName: "Your Song Name", // Pass the song name
                        imageUrl: "https://example.com/song-thumbnail.jpg", // Pass the image URL
                        //songDuration: Duration(minutes: 3, seconds: 45), // Pass song duration
                        onClose: audioPlayerProvider.hideMiniPlayer,
                      ),
                    )
                        : SizedBox.shrink();
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  
  
  @override
  
  void initState(){
    startTime();
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: Image.asset('assets/Sivavasagam.jpeg')
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  startTime() async {
    var duration = const Duration(seconds: 3);
    return Timer(duration, route);
  }
  route() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // var appstatus = prefs.getBool('isLoggedIn') ?? false;

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const Dashboard()));
  }
}

