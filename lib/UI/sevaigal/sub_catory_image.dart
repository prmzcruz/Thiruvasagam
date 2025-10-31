import 'package:flutter/material.dart';
import '../../model/sevaigal_modelclass.dart';
import '../../utility/color.dart';
import '../../utility/utility.dart';
import 'full_image.dart';

class sub_catogory_image extends StatelessWidget {
  final List<CatChild> catimages;
  const sub_catogory_image({super.key, required this.catimages});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back,color: HexColor(Colorscommon.whitecolor),),
        ),
        backgroundColor: HexColor(Colorscommon.red),
        title:  Text("Images", style: TextStyle(
            color: HexColor(Colorscommon.whitecolor),
          fontWeight: FontWeight.bold,
          fontSize: 20,
          fontFamily: 'MeeraInimai-Regular')),centerTitle: true,),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          itemCount: catimages.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
          ),
          itemBuilder: (context, index) {
            final image = catimages[index];
            print('image--${image.name}, ${image.id}');
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => FullImageViewer(
                      catimages: catimages,
                      initialIndex: index,
                    ),
                  ),
                );
              },
              child: Image.network(
                'https://sivavasagam.com/sivasadmin/storage/app/public/${image.path}',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.broken_image),
              ),
            );
          },
        ),
      ),
    );
  }
}
