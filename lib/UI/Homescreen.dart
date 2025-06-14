import 'package:flutter/material.dart';
import 'package:thiruvasagam/UI/sevaigal.dart';

import 'AudioPlayerPage.dart';
import 'Dashboard.dart';

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
          BottomNavigationBarItem(
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
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}