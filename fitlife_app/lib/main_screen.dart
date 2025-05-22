import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:fitlife_app/home_tab_content.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'custom widgets/custom_container.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Color color = Colors.white;
  int _currentIndex = 0;
  final List<Widget> _pages = [
    HomeTabContent(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 140,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundImage: AssetImage("assets/profile.jpg"),
                ),
                SizedBox(width: 20),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      Text(
                        "14-oct-2025",
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                      SizedBox(height: 14),
                      Text(
                        "Good Morning",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "You lose 500 g Today,Reach Your goal soon!",
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.lightGreen[400],
                borderRadius: BorderRadius.circular(16),
              ),
              padding: EdgeInsets.all(10),
              child: Icon(Icons.notifications_outlined, color: Colors.white),
            ),
          ),
        ],
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.white,
        color: Colors.greenAccent,
        index: _currentIndex,
        items: [
          BottomBarIconsContainer(
            currentIndex: _currentIndex,
            index: 0,
            iconData: FontAwesomeIcons.house,

          ),
          BottomBarIconsContainer(
            currentIndex: _currentIndex,
            index: 1,
            iconData: FontAwesomeIcons.chartBar,
          ),
          BottomBarIconsContainer(
            currentIndex: _currentIndex,
            index: 2,
            iconData: FontAwesomeIcons.tableColumns,
          ),
          BottomBarIconsContainer(
            currentIndex: _currentIndex,
            index: 3,
            iconData: FontAwesomeIcons.person,
          ),

        ],
        onTap: (index){
          setState(() {
            _currentIndex=index;
          });
        },
      ),
    );
  }
}
