import 'package:flutter/material.dart';
import 'package:thiruvasagam/UI/sevaigal/sevaigal.dart';
import 'package:thiruvasagam/utility/color.dart';
import 'package:thiruvasagam/utility/utility.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import 'thiruvasagam/AudioPlayerPage.dart';
import 'thiruvasagam/Dashboard.dart';
import 'package:package_info/package_info.dart';
import 'package:http/http.dart' as http;
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;


  // List of pages/screens
  final List<Widget> _pages = [
    const Dashboard(),
    const sevaigal(),
  ];


  @override
  void initState(){
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items:  [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'திருவாசகம்',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/sevaigal.jpeg',
              width: 24,
              height: 24,
            ),
            label: 'சேவைகள்',
          ),
        ],
        selectedItemColor: HexColor(Colorscommon.red),
        unselectedItemColor: HexColor(Colorscommon.greycolor),
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}