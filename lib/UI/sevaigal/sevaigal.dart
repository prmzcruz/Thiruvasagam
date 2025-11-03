import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:thiruvasagam/UI/sevaigal/sevaigal_viewpage.dart';
import 'package:thiruvasagam/UI/sevaigal/sub_catogory.dart';
import 'package:thiruvasagam/utility/color.dart';
import 'package:thiruvasagam/utility/utility.dart';

import '../../model/sevaigal_modelclass.dart';
import 'package:http/http.dart' as http;

class sevaigal extends StatefulWidget {
  const sevaigal({super.key});

  @override
  State<sevaigal> createState() => _sevaigalState();
}

class _sevaigalState extends State<sevaigal> {
  late Future<CategoryResponse> futureCategories;

  @override
  void initState() {
    super.initState();
    futureCategories = fetchCategories();
  }

  static Future<CategoryResponse> fetchCategories() async {
    final url = Uri.parse(
        'https://sivavasagam.com/sivasadmin/public/index.php/api/categories');
    final response = await http.get(url);

    if (response.statusCode == 200 || response.statusCode == 201) {
      final jsonBody = json.decode(response.body);
      log('Response Body: $jsonBody');
      return CategoryResponse.fromJson(jsonBody);
    } else {
      print('Failed to load categories. Status code: ${response.statusCode} ,${response.body}');
      throw Exception('Failed to load categories');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor(Colorscommon.whitecolor),
      body: FutureBuilder<CategoryResponse>(
        future: futureCategories,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.categories.isEmpty) {
            return Center(child: Text('No categories found.'));
          } else {
            final categories = snapshot.data!.categories;
            return Column(
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
                              fontFamily: 'MeeraInimai-Regular',),
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
                          itemCount: categories.length,
                          itemBuilder: (context, index) {
                            final category = categories[index];
                            return Column(
                              children: [
                                ListTile(
                                  // leading: Icon(Icons.category,
                                  //     color: Colors.deepPurple),
                                  title: Text(
                                    category.fullname,
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
                                    print('hello');
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                /*sevaigal_viewpage(
                                                  categoryname:
                                                      category.fullname,
                                                  catimages: category.catimages,
                                                  subcatimages:category.catimages.map((catimage) => catimage.catChildren).toList(),
                                                )*/
                                            sub_catogory(
                                              catimages: category.catimages,
                                              subcatimages: category.catimages.map((catimage) => catimage.catChildren).toList(),
                                            )
                                        ));
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
            );
          }
        },
      ),
    );
  }
}
