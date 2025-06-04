import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:fitlife_app/home_screen.dart';
import 'package:fitlife_app/progress_screen.dart';
import 'package:fitlife_app/user_and_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'blogs_screen.dart';
import 'custom widgets/custom_container.dart'; // Make sure this points to the updated BottomBarIconsContainer

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<MainScreen> {
  Color color = Colors.white;
  int _currentIndex = 0;
  final List<Widget> _pages = [
    HomeScreen(),
    ProgressScreen(),
    BlogsScreen(),
    UserAndProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(


      body: Container(
          color: Colors.white,
          child: _pages[_currentIndex]),
      bottomNavigationBar: CurvedNavigationBar(
        color: Color(0xFFE9FDE3),
        backgroundColor: Colors.transparent,
        //color: Colors.greenAccent,
        index: _currentIndex,
        items: [
          BottomBarIconsContainer(
            currentIndex: _currentIndex,
            index: 0,
            imagePath: 'assets/images/Home.svg',
          ),
          BottomBarIconsContainer(
            currentIndex: _currentIndex,
            index: 1,
            imagePath: 'assets/images/progress.svg',
          ),
          BottomBarIconsContainer(
            currentIndex: _currentIndex,
            index: 2,
            imagePath: 'assets/images/blog.svg',
          ),
          BottomBarIconsContainer(
            currentIndex: _currentIndex,
            index: 3,
            imagePath: 'assets/images/user.svg',
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),


    );
  }
}
