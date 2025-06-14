import 'package:flutter/material.dart';
import 'package:thiruvasagam/UI/sub_catory_image.dart';

import '../model/sevaigal_modelclass.dart';

class sevaigal_viewpage extends StatefulWidget {
  final String categoryname;
  final List<CatImage> catimages;
  final List<List<CatChild>> subcatimages;

  const sevaigal_viewpage(
      {super.key,
      required this.categoryname,
      required this.catimages,
      required this.subcatimages});

  @override
  State<sevaigal_viewpage> createState() => _sevaigal_viewpageState();
}

class _sevaigal_viewpageState extends State<sevaigal_viewpage> {
  @override
  Widget build(BuildContext context) {
    final CatImage? firstImage =
        widget.catimages.isNotEmpty ? widget.catimages[0] : null;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryname,style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 18,
            fontFamily: 'MeeraInimai-Regular')),
        centerTitle: true,
      ),
      body: firstImage == null
          ? const Center(child: Text("No image available"))
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Expanded(
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
                  const SizedBox(height: 16),
                  if (widget.subcatimages.first.isNotEmpty)
                    SizedBox(
                        width: double.infinity,
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => sub_catogory_image(
                                          catimages: widget.subcatimages
                                              .expand((list) => list)
                                              .toList(),
                                        )));
                          },
                          child: const Text(
                            'More Photos',
                            style: TextStyle(
                                color: Colors.blue,
                                fontSize: 15,
                                fontWeight: FontWeight.w600),
                          ),
                        )),
                ],
              ),
            ),
    );
  }
}
