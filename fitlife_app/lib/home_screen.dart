import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:fitlife_app/add_meals_screen.dart';
import 'package:fitlife_app/custom widgets/custom_list_tile.dart';
import 'package:fitlife_app/custom widgets/custom_text.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String? _profileImageUrl;

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
  }

  Future<void> _loadProfileImage() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final doc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .get();

      if (doc.exists && doc.data()?['profileImageUrl'] != null) {
        setState(() {
          _profileImageUrl = doc['profileImageUrl'];
        });
      }
    } catch (e) {
      debugPrint("⚠️ Failed to load profile image: $e");
    }
  }

  String getGreeting() {
    final hour = DateTime.now().hour;

    if (hour >= 5 && hour < 12) return 'Good Morning';
    if (hour >= 12 && hour < 17) return 'Good Afternoon';
    if (hour >= 17 && hour < 21) return 'Good Evening';
    return 'Good Night';
  }

  final List<String> todaysMeal = ['Bread', 'Lunch', 'Dinner'];
  final List<String> cheatMeal = ['Chicken Thigh'];
  final List<String> activity = ['Football', 'Cricket'];
  final List<String> fasting = ['Fasting'];

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      floatingActionButton: Container(
        height: 56,
        width: 56,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: const LinearGradient(
            colors: [Color(0xFF5AFF15), Color(0xFF00B712)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const AddMealsScreen()));
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: const Icon(Icons.add),
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.all(27),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ✅ Read-only Supabase avatar from Firestore
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.grey.shade200,
                    backgroundImage: _profileImageUrl != null
                        ? NetworkImage(_profileImageUrl!)
                        : const AssetImage("assets/images/Male.png")
                    as ImageProvider,
                  ),
                  const SizedBox(width: 25),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            DateTime.now().toString(),
                            style: const TextStyle(
                                fontSize: 16, color: Colors.black),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                getGreeting(),
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 8),
                              SvgPicture.asset("assets/images/hand.svg"),
                            ],
                          ),
                        ),
                        const SizedBox(height: 5),
                        const Center(
                          child: Text(
                            "You lost 500 g Today. Reach your goal soon!",
                            style:
                            TextStyle(fontSize: 14, color: Colors.black54),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    height: 45,
                    width: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF5AFF15), Color(0xFF00B712)],
                      ),
                    ),
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.notifications_outlined),
                    ),
                  ),
                ],
              ),
            ),

            buildCaloriesGraph(screenSize),
            const SizedBox(height: 10),
            const CustomText(text: "Today's Meal"),
            buildTodaysMeal(),
            const CustomText(text: "Cheat Meal"),
            buildCheatMeal(),
            const CustomText(text: "Activity"),
            buildActivity(),
            const CustomText(text: "Fasting"),
            buildFasting(),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  // same list builder methods as before ...

  Padding buildFasting() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: fasting.length,
        itemBuilder: (context, index) {
          return CustomListTile(
            title: fasting[index],
            leading: Image.asset("assets/images/rectangle.png"),
            subtitle: "12 hrs",
            trailing: IconButton(
              icon: const Icon(Icons.arrow_forward_ios),
              onPressed: () {},
            ),

            tileColor: const Color(0xFFFAFAFA),
          );
        },
      ),
    );
  }

  Padding buildActivity() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: activity.length,
        itemBuilder: (context, index) {
          return CustomListTile(
            title: activity[index],
            leading: Image.asset("assets/images/rectangle.png"),
            subtitle: "-250 kcal   20 mins",
            trailing:  IconButton(
          icon: const Icon(Icons.arrow_forward_ios),
          onPressed: () {},
          ),

          tileColor: const Color(0xFFFAFAFA),
          );
        },
      ),
    );
  }

  Padding buildCheatMeal() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: cheatMeal.length,
        itemBuilder: (context, index) {
          return CustomListTile(
            title: cheatMeal[index],
            leading: Image.asset("assets/images/rectangle.png"),
            subtitle: "3 Foods of 365 kcal",
            trailing: IconButton(
              icon: const Icon(Icons.arrow_forward_ios),
              onPressed: () {},
            ),

            tileColor: const Color(0xFFFAFAFA),
          );
        },
      ),
    );
  }

  Padding buildTodaysMeal() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        itemCount: todaysMeal.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return CustomListTile(
            title: todaysMeal[index],
            leading: Image.asset("assets/images/rectangle.png"),
            subtitle: "3 Foods of 365 kcal",
            trailing: IconButton(
              icon: const Icon(Icons.arrow_forward_ios),
              onPressed: () {},
            ),

            tileColor: const Color(0xFFFAFAFA),
          );
        },
      ),
    );
  }

  Padding buildCaloriesGraph(Size screenSize) {
    double containerHeight = screenSize.height * 0.32;
    if (containerHeight > 320) containerHeight = 320;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
      child: Container(
        height: containerHeight,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: const Color(0xFFE9FDE3),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              children: [
                const Spacer(flex: 2),
                Expanded(
                  flex: 2,
                  child: SfRadialGauge(
                    axes: [
                      RadialAxis(
                        minimum: 0,
                        maximum: 4000,
                        showLabels: false,
                        showTicks: false,
                        startAngle: 180,
                        endAngle: 0,
                        radiusFactor: 2.5,
                        ranges: [
                          GaugeRange(
                            startValue: 0,
                            endValue: 2000,
                            gradient: const SweepGradient(
                              colors: [Color(0xFF5AFF15), Color(0xFF00B712)],
                            ),
                            startWidth: 12,
                            endWidth: 12,
                          ),
                        ],
                        annotations: [
                          GaugeAnnotation(
                            widget: FittedBox(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset(
                                    "assets/images/Fire.png",
                                    height: constraints.maxHeight * 0.17,
                                    width: constraints.maxHeight * 0.17,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Calories",
                                    style: TextStyle(
                                      fontSize: constraints.maxHeight * 0.07,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "1200 kcal",
                                    style: TextStyle(
                                      fontSize: constraints.maxHeight * 0.07,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            angle: 90,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
