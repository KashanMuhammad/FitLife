import 'package:fitlife_admin_panel/analytics_screen.dart';
import 'package:fitlife_admin_panel/upload_blog_screen.dart';
import 'package:fitlife_admin_panel/customer_support.dart';
import 'package:fitlife_admin_panel/diet_screen.dart';
import 'package:fitlife_admin_panel/food_screen.dart';
import 'package:fitlife_admin_panel/upload_diet_screen.dart';
import 'package:fitlife_admin_panel/upload_food_screen.dart';
import 'package:fitlife_admin_panel/patient_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'admin_provider.dart';
import 'blog_screen.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool showDietUploadScreen = false;
  bool showFoodUploadScreen = false;
  bool showCreateBlogScreen = false;

  int selectedIndex = 2;
  Widget? selectedScreen;

  void showFoodForm(Map<String, dynamic> foodData) {
    setState(() {
      selectedIndex = 3;
      showFoodUploadScreen = true;
    });
  }
@override
@override
  void initState() {
  super.initState();
  // Reload admin name when dashboard opens
  WidgetsBinding.instance.addPostFrameCallback((_) {
    Provider.of<AdminProvider>(context, listen: false).getAdminName();
  });
  }
  @override
  Widget build(BuildContext context) {
    String adminName = Provider.of<AdminProvider>(context).adminName;
    return Scaffold(
      body: Row(
        children: [
          Container(
            width: 250,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF5AFF15), Color(0xFF00B712)],
              ),
              color: Colors.lightGreen.shade500,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
            ),
            child: buildNavigationRail(),
          ),
          Expanded(
            child: IndexedStack(
              index: selectedIndex,
              children: [
                // Center(child: Text("Analytics")),
                AnalyticsScreen(),
                UserScreen(),
                // Center(child: Text("Users")),
                showDietUploadScreen
                    ? UploadDietScreen()
                    : DietScreen(
                      onUploadPressed: () {
                        setState(() {
                          showDietUploadScreen = true;
                        });
                      },
                    ),
                showFoodUploadScreen
                    ? UploadFoodScreen()
                    : FoodScreen(
                      onUploadPressed: () {
                        setState(() {
                          showFoodUploadScreen = true;
                        });
                      },
                    ),
                CustomerSupportScreen(),

                showCreateBlogScreen
                    ? BlogFormScreen()
                    : BlogScreen(
                      onUploadPressed: () {
                        setState(() {
                          showCreateBlogScreen = true;
                        });
                      },
                    ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  NavigationRail buildNavigationRail() {
    return NavigationRail(
      leading: Column(
        children: [
          SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Fit",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  "Life",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          SizedBox(height: 25),
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
          label: Text("Patients"),
        ),
        NavigationRailDestination(
          icon: SvgPicture.asset('assets/diets.svg'),
          label: Text("Diets"),
        ),
        NavigationRailDestination(
          icon: SvgPicture.asset('assets/diets.svg'),
          label: Text("Food"),
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
      onDestinationSelected: (int value) {
        setState(() {
          selectedIndex = value;
          // Reset screen toggles
          if (value == 2) showDietUploadScreen = false;
          if (value == 3) showFoodUploadScreen = false;
          if (value == 5) showCreateBlogScreen = false;
        });
      },
    );
  }
}
