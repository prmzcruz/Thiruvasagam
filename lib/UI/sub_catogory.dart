import 'package:flutter/material.dart';
import 'package:thiruvasagam/UI/sevaigal_viewpage.dart';

import '../model/sevaigal_modelclass.dart';

class sub_catogory extends StatefulWidget {
  final List<CatImage> catimages;
  final List<List<CatChild>> subcatimages;
  const sub_catogory({super.key ,required this.catimages, required this.subcatimages});

  @override
  State<sub_catogory> createState() => _sub_catogoryState();
}

class _sub_catogoryState extends State<sub_catogory> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        backgroundColor: Colors.deepOrangeAccent,
      body: Column(
        children: [
          Container(
            child: const Padding(
              padding: EdgeInsets.all(30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'சேவைகள்',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          fontFamily: 'MeeraInimai-Regular'),
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
                ),
                child: Card(
                  color: Colors.white70,
                  child: ListView.builder(
                    itemCount: widget.catimages.length,
                    itemBuilder: (context, index) {
                      final category = widget.catimages[index];
                      return Column(
                        children: [
                          ListTile(
                            leading: Icon(Icons.category,
                                color: Colors.deepPurple),
                            title: Text(
                              category.name ?? '',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
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
                              final selectedSubCatImages = widget.subcatimages;

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => sevaigal_viewpage(
                                    categoryname: selectedCatImage.name ?? '',
                                    catimages: [selectedCatImage], // List<CatImage> with one item
                                    subcatimages: selectedSubCatImages, // List<CatChild>
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
