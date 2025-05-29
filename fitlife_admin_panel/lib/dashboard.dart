import 'package:fitlife_admin_panel/diet_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int selectedIndex =2;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Container(
            width: 250,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Color(0xFF5AFF15), Color(0xFF00B712)]),
              color: Colors.lightGreen.shade500,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
            ),
            child: NavigationRail(
              leading: Column(
                children: [
                  SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Fit",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          "Life",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 40),
                ],
              ),
              backgroundColor: Colors.transparent,
              labelType: NavigationRailLabelType.all,
              destinations: [
                NavigationRailDestination(
                  icon: SvgPicture.asset('assets/analytics.svg'),
                  label: Text("Analytics"),
                ),
                NavigationRailDestination(
                  icon: SvgPicture.asset('assets/users.svg'),
                  label: Text("Users"),
                ),
                NavigationRailDestination(
                  icon: SvgPicture.asset('assets/diets.svg'),
                  label: Text("Diets"),
                ),
                NavigationRailDestination(
                  icon: SvgPicture.asset('assets/support.svg'),
                  label: Text("Support"),
                ),
                NavigationRailDestination(
                  icon: SvgPicture.asset('assets/blogs.svg'),
                  label: Text("Blogs"),
                ),
              ],
              selectedIndex: selectedIndex,
              onDestinationSelected: (int value){
                setState(() {
                  selectedIndex = value;
                });
              },
            ),
          ),
          Expanded(child: IndexedStack(
            index: selectedIndex,
            children: [
              Text("Analytics"),
              Text("Users"),
              DietScreen(),
              Text("Support"),
              Text("Blogs"),
            ],
          ))
        ],
      ),
    );
  }
}
