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
  final String categoryName;

  const sevaigal_viewpage(
      {super.key,
        required this.catogoryId,
        required this.name,
        required this.address,
      required this.categoryname,
      required this.description,
      required this.catimages,
      required this.subcatimages, required this.categoryName});

  @override
  State<sevaigal_viewpage> createState() => _sevaigal_viewpageState();
}

class _sevaigal_viewpageState extends State<sevaigal_viewpage> {
  late List<CatChild> allSubCatImages;

  @override
  void initState() {
    super.initState();
    allSubCatImages = widget.subcatimages.expand((list) => list).toList();
  }

  @override
  Widget build(BuildContext context) {
    final CatImage? firstImage =
        widget.catimages.isNotEmpty ? widget.catimages[0] : null;
    final bool hasSubCatImages = allSubCatImages.isNotEmpty;
    final CatChild? firstSubCat = hasSubCatImages ? allSubCatImages.first : null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.categoryname,
          style: TextStyle(
            color: HexColor(Colorscommon.whitecolor),
            fontWeight: FontWeight.bold,
            fontSize: 20,
            fontFamily: 'MeeraInimai-Regular',
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back,color: HexColor(Colorscommon.whitecolor),),
        ),
        centerTitle: true,
        backgroundColor: HexColor(Colorscommon.red),
      ),
      backgroundColor: Colors.white,
      body:Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 80), // To avoid overlap with button
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  firstSubCat?.name ?? '',
                  style: TextStyle(
                    color: HexColor(Colorscommon.blackcolor),
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'MeeraInimai-Regular',
                  ),
                ),
                const SizedBox(height: 15),
                InteractiveViewer(
                  panEnabled: true,
                  minScale: 1.0,
                  maxScale: 4.0,
                  child: Image.network(
                    'https://sivavasagam.com/sivasadmin/storage/app/public/${firstImage?.path}',
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(child: CircularProgressIndicator());
                    },
                    errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.broken_image, size: 100),
                  ),
                ),
                const SizedBox(height: 20),
                if (firstSubCat?.description != null)
                  if (widget.categoryName.contains("கோவில் உழவாரப்பணி") ||
                      widget.categoryName.contains("மஹாகும்பாபிஷேகம்"))
                    Center(
                      child: Text(
                        'தல வரலாறு',
                        style: TextStyle(
                          color: HexColor(Colorscommon.blackcolor),
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'MeeraInimai-Regular',
                        ),
                      ),
                    ),
                const SizedBox(height: 10),
                Text(
                  firstSubCat?.description ?? '',
                  style: TextStyle(
                    color: HexColor(Colorscommon.blackcolor),
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'MeeraInimai-Regular',
                  ),
                ),
                const SizedBox(height: 25),
                if(firstSubCat?.address != null)
                  if (widget.categoryName.contains("கோவில் உழவாரப்பணி") ||
                      widget.categoryName.contains("மஹாகும்பாபிஷேகம்"))
                Center(
                  child: Text(
                    'முகவரி',
                    style: TextStyle(
                      color: HexColor(Colorscommon.blackcolor),
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'MeeraInimai-Regular',
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  firstSubCat?.address ?? '',
                  style: TextStyle(
                    color: HexColor(Colorscommon.blackcolor),
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'MeeraInimai-Regular',
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),

          // ✅ Fixed bottom button
          if (allSubCatImages.length > 1)
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: SizedBox(
                width: double.infinity,
                height: 55,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => sub_catogory_image(
                          catimages: allSubCatImages,
                        ),
                      ),
                    );
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'More Photos',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),

    );
  }
}
