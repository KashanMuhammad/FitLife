import 'package:flutter/material.dart';

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
                  icon: Icon(Icons.analytics_rounded),
                  label: Text("Analytics"),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.person),
                  label: Text("Users"),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.emoji_food_beverage_outlined),
                  label: Text("Diets"),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.support_agent_outlined),
                  label: Text("Support"),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.book_online_outlined),
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
              Text("Support"),
              Text("Blogs"),
            ],
          ))
        ],
      ),
    );
  }
}
