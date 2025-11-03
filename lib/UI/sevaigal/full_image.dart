import 'package:flutter/material.dart';
import '../../model/sevaigal_modelclass.dart';
import '../../utility/color.dart';
import '../../utility/utility.dart';

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
        backgroundColor: HexColor(Colorscommon.red),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back, color: HexColor(Colorscommon.whitecolor)),
        ),
        title: Text(
          currentImage.name ?? '',
          style: TextStyle(
            color: HexColor(Colorscommon.whitecolor),
            fontWeight: FontWeight.bold,
            fontSize: 20,
            fontFamily: 'MeeraInimai-Regular',
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 80), // avoid button overlap
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InteractiveViewer(
                  panEnabled: true,
                  minScale: 1,
                  maxScale: 4,
                  child: Image.network(
                    'https://sivavasagam.com/sivasadmin/storage/app/public/${currentImage.path}',
                    errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.broken_image, size: 100),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    currentImage.description ?? 'No description available',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'MeeraInimai-Regular',
                    ),
                  ),
                ),
                const SizedBox(height: 80), // extra space for button
              ],
            ),
          ),

          // Fixed Next & Previous buttons
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: currentIndex > 0 ? showPreviousImage : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: const Text("Previous",
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                ),
                ElevatedButton(
                  onPressed:
                  currentIndex < widget.catimages.length - 1 ? showNextImage : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: const Text("Next",
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
