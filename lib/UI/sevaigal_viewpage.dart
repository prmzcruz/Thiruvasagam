import 'package:flutter/material.dart';

import '../model/sevaigal_modelclass.dart';

class sevaigal_viewpage extends StatefulWidget {
  final String categoryname;
  final List<CatImage> catimages;

  const sevaigal_viewpage({
    super.key,
    required this.categoryname,
    required this.catimages,
  });

  @override
  State<sevaigal_viewpage> createState() => _sevaigal_viewpageState();
}

class _sevaigal_viewpageState extends State<sevaigal_viewpage> {
  @override
  Widget build(BuildContext context) {
    final CatImage? firstImage = widget.catimages.isNotEmpty ? widget.catimages[0] : null;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryname),
        centerTitle: true,
      ),
      body: firstImage == null
          ? const Center(child: Text("No image available"))
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: InteractiveViewer(
          panEnabled: true,
          minScale: 1.0,
          maxScale: 4.0,
          child: Image.network(
            'https://sivavasagam.com/sivasadmin/storage/app/public/${firstImage.path}',
            errorBuilder: (context, error, stackTrace) =>
            const Icon(Icons.broken_image),
          ),
        ),
      ),
    );
  }
}

