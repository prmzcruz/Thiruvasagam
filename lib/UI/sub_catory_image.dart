import 'package:flutter/material.dart';
import '../model/sevaigal_modelclass.dart';
import 'full_image.dart';

class sub_catogory_image extends StatelessWidget {
  final List<CatChild> catimages;
  const sub_catogory_image({super.key, required this.catimages});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Images", style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w600,
          fontSize: 18,
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
