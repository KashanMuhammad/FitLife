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
      appBar: AppBar(
        toolbarHeight: 140,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.start, // avatar aligns top
          children: [
            // Avatar top aligned
            CircleAvatar(
              radius: 24,
              child: Image.asset("assets/images/Male.png"),
            ),
            SizedBox(width: 20),

            // Column vertically centered inside available height
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,  
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Center(
                      child: Text(
                        "14-oct-2025",
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ),
                    SizedBox(height: 14),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Good Morning",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SvgPicture.asset("assets/images/hand.svg")
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Center(
                      child: Text(
                        "You lose 500 g Today,Reach Your goal soon!",
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Container(
              decoration: BoxDecoration(
               // gradient: LinearGradient(
                 //   colors: [Color(0xFF5AFF15), Color(0xFF00B712)],
                //),
                borderRadius: BorderRadius.circular(23),
                color: Color(0xFF00B712)
              ),
              padding: EdgeInsets.all(10),
              child: IconButton(
                onPressed: () {},
                icon: Icon(Icons.notifications_outlined, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
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
