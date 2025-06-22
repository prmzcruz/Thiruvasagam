import 'package:flutter/material.dart';
import '../model/sevaigal_modelclass.dart';

class FullImageViewer extends StatefulWidget {
  final List<CatChild> catimages;
  final int initialIndex;

  const FullImageViewer({
    super.key,
    required this.catimages,
    required this.initialIndex,
  });

  @override
  State<FullImageViewer> createState() => _FullImageViewerState();
}

class _FullImageViewerState extends State<FullImageViewer> {
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
  }

  void showNextImage() {
    if (currentIndex < widget.catimages.length - 1) {
      setState(() => currentIndex++);
    }
  }

  void showPreviousImage() {
    if (currentIndex > 0) {
      setState(() => currentIndex--);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentImage = widget.catimages[currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(currentImage.name,style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 18,
            fontFamily: 'MeeraInimai-Regular')),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: InteractiveViewer(
                panEnabled: true,
                minScale: 1,
                maxScale: 4,
                child: Image.network(
                  'https://sivavasagam.com/sivasadmin/storage/app/public/${currentImage.path}',
                  errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.broken_image),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: currentIndex > 0 ? showPreviousImage : null,
                  child: const Text("Previous",style: TextStyle(color: Colors.blue,fontSize: 15,fontWeight: FontWeight.w600)),
                ),
                TextButton(
                  onPressed: currentIndex < widget.catimages.length - 1
                      ? showNextImage
                      : null,
                  child: const Text("Next",style: TextStyle(color: Colors.blue,fontSize: 15,fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ),
        ],
      ),

    );
  }
}
