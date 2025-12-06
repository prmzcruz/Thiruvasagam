import 'package:flutter/material.dart';
import 'package:thiruvasagam/UI/sevaigal/sevaigal_viewpage.dart';
import 'package:thiruvasagam/utility/color.dart';
import 'package:thiruvasagam/utility/utility.dart';

import '../../model/sevaigal_modelclass.dart';

class sub_catogory extends StatefulWidget {
  final List<CatImage> catimages;
  final List<List<CatChild>> subcatimages;
  final String categoryname;
  const sub_catogory({super.key ,required this.catimages, required this.subcatimages,required this.categoryname});

  @override
  State<sub_catogory> createState() => _sub_catogoryState();
}

class _sub_catogoryState extends State<sub_catogory> {

  String _getCurrentDate() {
    final now = DateTime.now();

    final dayNameTamil = [
      'திங்கட்கிழமை',   // Monday
      'செவ்வாய்க்கிழமை', // Tuesday
      'புதன்கிழமை',     // Wednesday
      'வியாழக்கிழமை',   // Thursday
      'வெள்ளிக்கிழமை',  // Friday
      'சனிக்கிழமை',     // Saturday
      'ஞாயிற்றுக்கிழமை' // Sunday
    ][now.weekday - 1];

    return "$dayNameTamil-${now.day.toString().padLeft(2, '0')}-"
        "${now.month.toString().padLeft(2, '0')}-"
        "${now.year}";
  }


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        backgroundColor: HexColor(Colorscommon.whitecolor),
      body: Column(
        children: [
          Container(
            color: HexColor(Colorscommon.red),
            child:  Padding(
              padding: EdgeInsets.all(30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'சேவைகள்',
                      style: TextStyle(
                        color: HexColor(Colorscommon.whitecolor),
                        fontWeight: FontWeight.w600,
                        fontSize: 25,
                        fontFamily: 'MeeraInimai-Regular',
                      ),
                    ),
                  ),

                  SizedBox(height: 5),

                  // Show current date
                  Text(
                    _getCurrentDate(),     // <-- call function
                    style: TextStyle(
                      color: HexColor(Colorscommon.whitecolor),
                        fontSize: 22,
                        fontFamily: 'MeeraInimai-Regular',
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 10,
                  right: 10,
                  top: 16
                ),
                child: Card(
                  color: Colors.white,
                  elevation: 5,
                  child: ListView.builder(
                    itemCount: widget.catimages.length,
                    itemBuilder: (context, index) {
                      final category = widget.catimages[index];
                      return Column(
                        children: [
                          ListTile(
                            // leading: Icon(Icons.category,
                            //     color: Colors.deepPurple),
                            title: Text(
                              category.name ?? '',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'MeeraInimai-Regular',
                              ),
                            ),
                            //subtitle: Text(category.fullname),
                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              size: 15,
                              color: Colors.grey,
                            ),
                            onTap: () {
                              final selectedCatImage = widget.catimages[index];
                              final selectedSubCatImages = widget.subcatimages[index];

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => sevaigal_viewpage(
                                    categoryName:widget.categoryname,
                                    catogoryId:selectedCatImage.id.toString() ?? '',
                                    categoryname: selectedCatImage.name ?? '',
                                    name: selectedCatImage.name ?? '',
                                    description:selectedCatImage.description ?? '',
                                    address: selectedCatImage.address ?? '',
                                    catimages: [selectedCatImage], // List<CatImage> with one item
                                    subcatimages: [selectedSubCatImages], // List<CatChild>
                                  ),
                                ),
                              );
                            },
                          ),
                          const Padding(
                              padding:
                              EdgeInsets.only(left: 10, right: 10),
                              child: Divider(
                                thickness: 0.5,
                                color: Colors.black12,
                              )),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      )
    );
  }
}
