import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:thiruvasagam/UI/AudioPlayerPage.dart';
import 'package:thiruvasagam/UI/videopage.dart';

class ContentPage extends StatefulWidget {
  final int id;
  final String audioUrl;
  final String videoUrl;
  final String desc;
  final String name;
  final String thumbline;
  final String videoId;

  const ContentPage({
    Key? key,
    required this.id,
    required this.audioUrl,
    required this.videoUrl,
    required this.desc,
    required this.name,
    required this.thumbline,
    required this.videoId
  }) : super(key: key);

  @override
  State<ContentPage> createState() => _ContentPageState();
}

class _ContentPageState extends State<ContentPage> {
  double _zoomLevel = 1.5;
  ScrollController _scrollbarController = ScrollController();

  @override
  Widget build(BuildContext context) {
    print('Audio URL: ${widget.audioUrl}');
    print('Video URL: ${widget.videoUrl}');
    print('Description: ${widget.desc}');
    print('Name: ${widget.name}');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrangeAccent,
        elevation: 5.0,
        title: Text(
          widget.name,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black, fontFamily: 'MeeraInimai-Regular'),
        ),
        centerTitle: true,
        actions: [
          /*IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => videopage(videoId: widget.videoId, name: widget.name, thumblineimg: widget.thumbline),
                ),
              );
            },
            icon: Icon(Icons.play_circle),
            color: Colors.red,
          ),*/
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AudioPlayerPage(id: widget.id, audioUrl: widget.audioUrl, thumblineimg: widget.thumbline),
                ),
              );
            },
            icon: ClipOval(
              child: Image.asset(
                'assets/audioicon1.jpeg',
                width: 25,
                height: 25,
                fit: BoxFit.cover,
              ),
            ),
            // color: Colors.blueAccent,
          ),
        ],
      ),
      body: Stack(
        children: [
          Center(
            child: Opacity(
              opacity: 0.2,
              child: Image.asset('assets/Natarajphoto 1.jpg'), // Replace with your asset image path
            ),
          ),
          Column(
            children: [
              Expanded(
                child: Theme(
                  data: ThemeData(
                    highlightColor: Colors.blueAccent, // Does not work
                  ),
                  child: Scrollbar(
                    controller: _scrollbarController,
                    //isAlwaysShown: true,
                    thickness: 3,
                    child: SingleChildScrollView(
                      controller: _scrollbarController,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 20),
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  return ConstrainedBox(
                                    constraints: BoxConstraints(
                                      maxWidth: constraints.maxWidth,
                                    ),
                                    child: HtmlWidget(
                                      widget.desc,
                                      textStyle: TextStyle(
                                          fontSize: 12 * _zoomLevel,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'MeeraInimai-Regula'),
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                color: Colors.white,
                child: Slider(
                  value: _zoomLevel,
                  min: 1,
                  max: 3,
                  activeColor: Colors.blueAccent,
                  inactiveColor: Colors.grey,
                  onChanged: (value) {
                    setState(() {
                      _zoomLevel = value;
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
