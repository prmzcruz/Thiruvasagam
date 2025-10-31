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
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back,color: HexColor(Colorscommon.whitecolor),),
        ),
        title: Text(currentImage.name,style:  TextStyle(
            color: HexColor(Colorscommon.whitecolor),
            fontWeight: FontWeight.bold,
            fontSize: 20,
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
          Text(currentImage.description ?? 'No description available',style: const TextStyle(
              color: Colors.black,
              fontSize: 15,
              fontWeight: FontWeight.w600)),
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
