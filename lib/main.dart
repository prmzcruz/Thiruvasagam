import 'dart:async';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thiruvasagam/UI/AudioBackground/Audioplayerprovider.dart';
import 'package:thiruvasagam/UI/thiruvasagam/Dashboard.dart';
import 'package:thiruvasagam/UI/thiruvasagam/Miniplayer.dart';
import 'UI/Homescreen.dart';


class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Handle background message
  print('Handling a background message: ${message.messageId}');
  RemoteNotification? notification = message.notification;
  if (notification != null) {
    print('Notification Title: ${notification.title}');
    print('Notification Body: ${notification.body}');
  }
}

Future<void> backgroundHandler(RemoteMessage message) async {
  // print(message.notification?.title);
  // print(message.data.toString());
  await Firebase.initializeApp();
}


Future<void> main() async{

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  WidgetsFlutterBinding.ensureInitialized();

  HttpOverrides.global = MyHttpOverrides();
  await Permission.notification.isDenied.then((value) {
    if (value) {
      Permission.notification.request();
    }
  });
  await requestNotificationPermission();
  await Firebase.initializeApp();
  FirebaseMessaging firebaseFCM = FirebaseMessaging.instance;
  FirebaseMessaging.instance.getInitialMessage();

  var initialzationSettingsAndroid =
  const AndroidInitializationSettings('@mipmap/ic_launcher');
  var initializationSettings =
  InitializationSettings(android: initialzationSettingsAndroid,);
  flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (payload) async {
        if (payload != null && payload.isNotEmpty) {
          var notifytsqid = payload.substring(payload.indexOf(':') + 3);

          print("flutterLocalNotification payload = ${payload.toString()}");
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setBool('fromnotify', true);
          // if (appstatus == true) {
          /*navigatorKey.currentState?.push(
            MaterialPageRoute(builder: (_) => const MyTabPage(selectedtab: 2, title: '',)),
          );*/
          // } else {
          //   // Fluttertoast.showToast(msg:AppLocalizations.of(context)!.id);
          // }
        } else {
          print("No data in flutterLocalNotificationsPlugin payload");
        }
      });
  firebaseFCM.getToken().then((token) {
    assert(token != null);
  });
  String token;
  token = (await firebaseFCM.getToken())!;
  print("fcm token =  $token");
  if (Platform.isIOS) {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );
  }
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('onmessage..');
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    AppleNotification? apple = message.notification?.apple;
    if (Platform.isAndroid) {
      if (notification != null && android != null) {
        print("push onMessage = ${notification.body.toString()}");

        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title, // Title of our notification
            notification.body, // Body of our notification
            const NotificationDetails(
                android: AndroidNotificationDetails(
                    "1",
                    "sivavasagam",
                    channelDescription: "sivavasagam",
                    importance: Importance.high,
                    priority: Priority.high,
                    //styleInformation: BigTextStyleInformation("null"),
                    largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher')
                ),
               ),
            // payload: message.data["view"]);
            payload: notification.body.toString());
        // String? data = notification.title;
        // print("notification data = $data");
      }
    }
  });
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
    print('onmessageopenedapp..');
    RemoteNotification? notification = message.notification;

    flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification?.title,
        notification?.body,
        const NotificationDetails(
            android: AndroidNotificationDetails(
                "1",
                "sivavasagam",
                channelDescription: "sivavasagam",
                importance: Importance.high,
                priority: Priority.high,
                largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher')
            ),
        ),
        payload: notification?.body);

    /*navigatorKey.currentState?.push(
      MaterialPageRoute(builder: (_) => const MyTabPage(selectedtab: 2, title: '',)),
    );*/
  });
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
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

Future<void> requestNotificationPermission() async {
  if (await Permission.notification.isDenied) {
    await Permission.notification.request();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.red,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
      ),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Sivavasagam',
        theme: ThemeData(
          primaryColor: Colors.red,
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.transparent,
            primary: Colors.red,
          ),

        ),
        home: Stack(
          children: [
            Container(color: Colors.white),
            const SafeArea(child: Splashscreen()),
          ],
        ),
      ),
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
                        songName: "song name", // Pass the song name
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
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset(
              'assets/splash_img.jpeg',
              fit: BoxFit.cover,
            ),
          ),
          const Positioned(
            bottom: 5,
            left: 0,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'மாணிக்கவாசகர்',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'MeeraInimai-Regular',
                    shadows: [
                      Shadow(
                        offset: Offset(2, 2),
                        blurRadius: 6,
                        color: Colors.black45,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Version 1.2',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'MeeraInimai-Regular',
                    shadows: [
                      Shadow(
                        offset: Offset(1, 1),
                        blurRadius: 4,
                        color: Colors.black38,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

    );

  }
  startTime() async {
    var duration = const Duration(seconds: 3);
    return Timer(duration, route);
  }
  route() async {

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const HomeScreen()));
  }
}

