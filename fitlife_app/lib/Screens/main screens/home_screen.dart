import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import 'package:shared/user_0nboarding_data_model_class.dart';

import '../custom widgets/custom_list_tile.dart';
import '../custom widgets/custom_text.dart';
import '../meals/add_meals_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String? _profileImageUrl;
  FirebaseDataModelClass? userData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
    _loadUserMeals();
  }

  Future<void> _loadProfileImage() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final doc =
          await FirebaseFirestore.instance
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

  Future<void> _loadUserMeals() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final doc =
          await FirebaseFirestore.instance
              .collection('Users')
              .doc(user.uid)
              .get();

      if (doc.exists) {
        setState(() {
          userData = FirebaseDataModelClass.fromJson(doc.data()!);
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      debugPrint("⚠️ Error loading meals: $e");
      setState(() => _isLoading = false);
    }
  }

  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) return 'Good Morning';
    if (hour >= 12 && hour < 17) return 'Good Afternoon';
    if (hour >= 17 && hour < 21) return 'Good Evening';
    return 'Good Night';
  }

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
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddMealsScreen()),
            );
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: const Icon(Icons.add),
        ),
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    Padding(
                      padding: const EdgeInsets.all(27),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.grey.shade200,
                            backgroundImage:
                                _profileImageUrl != null
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
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
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
                                      SvgPicture.asset(
                                        "assets/images/hand.svg",
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 5),
                                const Center(
                                  child: Text(
                                    "You lost 500 g Today. Reach your goal soon!",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black54,
                                    ),
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
                    const CustomText(text: "Today's Meals"),
                    buildTodaysMeal(),
                    const CustomText(text: "Cheat Meals"),
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

  // ✅ Updated Today's Meals - shows Breakfast, Lunch, Dinner counts
  Widget buildTodaysMeal() {
    if (userData == null || userData!.userSelectedFood == null) {
      return const Padding(
        padding: EdgeInsets.all(8.0),
        child: Text(
          "No meals found today",
          style: TextStyle(fontSize: 16, color: Colors.black54),
        ),
      );
    }

    final List<FoodModel> foods = userData!.userSelectedFood ?? [];
    final today = DateTime.now();

    // Filter today's foods
    final todaysFoods =
        foods.where((food) {
          return food.consumptions.any((c) {
            final date = DateTime.tryParse(c.date) ?? DateTime.now();
            return date.year == today.year &&
                date.month == today.month &&
                date.day == today.day;
          });
        }).toList();

    if (todaysFoods.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(8.0),
        child: Text(
          "No meals consumed today",
          style: TextStyle(fontSize: 16, color: Colors.black54),
        ),
      );
    }

    // Count by mealType
    int breakfastCount = 0;
    int lunchCount = 0;
    int dinnerCount = 0;

    for (var food in todaysFoods) {
      for (var c in food.consumptions) {
        final date = DateTime.tryParse(c.date) ?? DateTime.now();
        if (date.year == today.year &&
            date.month == today.month &&
            date.day == today.day) {
          switch (c.mealType.toLowerCase()) {
            case "breakfast":
              breakfastCount++;
              break;
            case "lunch":
              lunchCount++;
              break;
            case "dinner":
              dinnerCount++;
              break;
          }
        }
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6),
      child: Column(
        children: [
          CustomListTile(
            title: "Breakfast",
            leading: Image.asset(
              "assets/images/rectangle.png",
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
            subtitle: "$breakfastCount foods selected",
            trailing: IconButton(
              onPressed: () {},
              icon: Icon(Icons.arrow_forward_ios),
            ),
            tileColor: const Color(0xFFFAFAFA),
          ),
          const SizedBox(height: 8),
          CustomListTile(
            title: "Lunch",
            leading: Image.asset(
              "assets/images/rectangle.png",
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
            subtitle: "$lunchCount foods selected",
            trailing: IconButton(
              onPressed: () {},
              icon: Icon(Icons.arrow_forward_ios),
            ),
            tileColor: const Color(0xFFFAFAFA),
          ),
          const SizedBox(height: 8),
          CustomListTile(
            title: "Dinner",
            leading: Image.asset(
              "assets/images/rectangle.png",
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
            subtitle: "$dinnerCount foods selected",
            trailing: IconButton(
              onPressed: () {},
              icon: Icon(Icons.arrow_forward_ios),
            ),
            tileColor: const Color(0xFFFAFAFA),
          ),
        ],
      ),
    );
  }

  // 🔹 Cheat Meals (foods over 500 kcal)
  Widget buildCheatMeal() {
    if (userData == null || userData!.userSelectedFood == null) {
      return const Padding(
        padding: EdgeInsets.all(8.0),
        child: Text(
          "No cheat meals found",
          style: TextStyle(fontSize: 16, color: Colors.black54),
        ),
      );
    }

    final List<FoodModel> foods = userData!.userSelectedFood ?? [];
    final cheatFoods =
        foods
            .where(
              (f) =>
                  double.tryParse(f.calories) != null &&
                  double.parse(f.calories) > 500,
            )
            .toList();

    if (cheatFoods.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(8.0),
        child: Text(
          "No cheat meals today",
          style: TextStyle(fontSize: 16, color: Colors.black54),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: cheatFoods.length,
        itemBuilder: (context, index) {
          final food = cheatFoods[index];
          return CustomListTile(
            title: food.foodName,
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                food.foodImageUrl ?? 'https://via.placeholder.com/60',
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
            subtitle: "${food.calories} kcal",
            trailing: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.arrow_forward_ios),
            ),
            tileColor: const Color(0xFFFAFAFA),
          );
        },
      ),
    );
  }

  Padding buildActivity() {
    final List<String> activity = ['Football', 'Cricket'];
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

  Padding buildFasting() {
    final List<String> fasting = ['Fasting'];
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
