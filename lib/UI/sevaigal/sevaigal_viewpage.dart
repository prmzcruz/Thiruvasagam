import 'package:flutter/material.dart';
import 'package:thiruvasagam/UI/sevaigal/sub_catory_image.dart';

import '../../model/sevaigal_modelclass.dart';
import '../../utility/color.dart';
import '../../utility/utility.dart';

class sevaigal_viewpage extends StatefulWidget {
  final String catogoryId;
  final String categoryname;
  final String description;
  final String name;
  final String address;
  final List<CatImage> catimages;
  final List<List<CatChild>> subcatimages;

  const sevaigal_viewpage(
      {super.key,
        required this.catogoryId,
        required this.name,
        required this.address,
      required this.categoryname,
      required this.description,
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

    final List<CatChild> subCategoryImages =
        firstImage?.catChildren ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryname,style: const TextStyle(
            color: Colors.black,

            fontWeight: FontWeight.w600,
            fontSize: 18,
            fontFamily: 'MeeraInimai-Regular')),
        centerTitle: true,
        backgroundColor: HexColor(Colorscommon.red),
      ),
      backgroundColor: Colors.white,
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
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },

                        errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.broken_image),
                      ),
                    ),
                  ),
                  Center(child: Text(widget.address,style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.w600))),

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
                                          // catimages: widget.subcatimages
                                          //     .expand((list) => list)
                                          //     .toList(),
                                        catimages: subCategoryImages
                                        )));
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.red,
                              fixedSize: const Size(90, 60),
                            padding: const EdgeInsets.all(16),
                          ),
                          child: const Text(
                            'More Photos',
                            style: TextStyle(
                                color: Colors.white,
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
