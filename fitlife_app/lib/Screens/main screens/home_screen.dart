import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../custom widgets/custom_list_tile.dart';
import '../custom widgets/custom_text.dart';
import '../customer support/customer_support.dart';
import '../meals/add_meals_screen.dart';
import '../meals/meal_detail_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String? _profileImageUrl;
  String userId = '';
  final supabase = Supabase.instance.client;

  // Store user data directly as Maps
  Map<String, dynamic>? userData;
  List<Map<String, dynamic>> userSelectedFoods = [];
  bool _isLoading = true;

  // Today's statistics
  int todayTotalCalories = 0;
  int todayGoalCalories = 7000; // Daily goal
  Map<String, int> todayMealsCount = {};
  Map<String, List<Map<String, dynamic>>> todayMealsDetails = {};

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    userId = user.uid;

    try {
      final doc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .get();

      if (doc.exists) {
        final data = doc.data()!;

        setState(() {
          userData = data;
          _profileImageUrl = data['profileImageUrl'];

          // Load user selected foods
          if (data.containsKey('userSelectedFood') && data['userSelectedFood'] != null) {
            userSelectedFoods = List<Map<String, dynamic>>.from(data['userSelectedFood']);
          }

          _isLoading = false;
          _calculateTodayStatistics();
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      debugPrint("⚠️ Error loading user data: $e");
      setState(() => _isLoading = false);
    }
  }

  /// Upload profile image to Supabase and update Firestore
  Future<void> _uploadProfileImage() async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      // Pick image from gallery
      final picker = ImagePicker();
      final image = await picker.pickImage(source: ImageSource.gallery);
      if (image == null) {
        if (mounted) Navigator.pop(context);
        return;
      }

      // Read image bytes
      final bytes = await image.readAsBytes();

      // Generate unique file name
      final fileName = "${DateTime.now().millisecondsSinceEpoch}.jpg";
      final filePath = "$userId/$fileName";

      // Upload to Supabase storage using PROFILE_IMAGES bucket (uppercase)
      await supabase.storage.from("profile_images").uploadBinary(
        filePath,
        bytes,
        fileOptions: const FileOptions(cacheControl: '3600', upsert: true),
      );

      // Get public URL
      final imageUrl = supabase.storage.from("PROFILE_IMAGES").getPublicUrl(filePath);

      // Update Firestore user document
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .update({
        'profileImageUrl': imageUrl,
        'profileImageUpdatedAt': FieldValue.serverTimestamp(),
      });

      // Update local state
      if (mounted) {
        setState(() {
          _profileImageUrl = imageUrl;
          if (userData != null) {
            userData!['profileImageUrl'] = imageUrl;
          }
        });
      }

      // Close loading dialog
      if (mounted) Navigator.pop(context);

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Profile image updated successfully!"),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }

    } catch (e) {
      // Close loading dialog if still open
      if (mounted && Navigator.canPop(context)) {
        Navigator.pop(context);
      }

      debugPrint("Error uploading profile image: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to upload image: ${e.toString()}"),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  void _calculateTodayStatistics() {
    if (userSelectedFoods.isEmpty) {
      todayTotalCalories = 0;
      todayMealsCount = {};
      todayMealsDetails = {};
      return;
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    todayTotalCalories = 0;
    todayMealsCount = {
      'Meal 1': 0,
      'Meal 2': 0,
      'Meal 3': 0,
    };
    todayMealsDetails = {
      'Meal 1': [],
      'Meal 2': [],
      'Meal 3': [],
    };

    for (var food in userSelectedFoods) {
      // Check if food has consumptions array
      if (food.containsKey('consumptions') && food['consumptions'] != null && food['consumptions'].isNotEmpty) {
        List<dynamic> consumptions = food['consumptions'];

        for (var consumption in consumptions) {
          Map<String, dynamic> consMap = Map<String, dynamic>.from(consumption);

          // Get the date from consumption
          String dateStr = consMap['date'] ?? '';
          DateTime consumptionDate = DateTime.tryParse(dateStr) ?? DateTime.now();
          DateTime consumptionDateOnly = DateTime(consumptionDate.year, consumptionDate.month, consumptionDate.day);

          // Check if it's today
          if (consumptionDateOnly == today) {
            // Get quantity
            int qty = 1;
            if (consMap.containsKey('foodQuantity')) {
              qty = int.tryParse(consMap['foodQuantity'].toString()) ?? 1;
            }

            // Get calories
            int caloriesPerServing = 0;
            if (food.containsKey('calories')) {
              caloriesPerServing = int.tryParse(food['calories'].toString()) ?? 0;
            }

            int totalCalories = qty * caloriesPerServing;
            todayTotalCalories += totalCalories;

            // Get meal type
            String mealType = consMap['mealType'] ?? food['mealType'] ?? 'Meal 1';

            // Count meals
            if (todayMealsCount.containsKey(mealType)) {
              todayMealsCount[mealType] = todayMealsCount[mealType]! + 1;
            } else {
              todayMealsCount[mealType] = 1;
            }

            // Store meal details
            Map<String, dynamic> mealDetail = {
              'foodName': food['foodName'] ?? 'Unknown',
              'calories': caloriesPerServing,
              'totalCalories': totalCalories,
              'quantity': qty,
              'foodImageUrl': food['foodImageUrl'] ?? '',
              'foodDescription': food['foodDescription'] ?? '',
              'consumptionTime': consMap['date'] ?? '',
            };

            if (todayMealsDetails.containsKey(mealType)) {
              todayMealsDetails[mealType]!.add(mealDetail);
            } else {
              todayMealsDetails[mealType] = [mealDetail];
            }
          }
        }
      }
    }

    // Force UI update
    setState(() {});
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
      floatingActionButton: Stack(
        children: [
          // Position the chat button on the LEFT side
          Positioned(
            left: 20,
            bottom: 0,
            child: Container(
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
                heroTag: "chat_button",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserCustomerSupportScreen(
                        userId: userId,
                        userName: userData?['name'] ?? 'User',
                      ),
                    ),
                  );
                },
                backgroundColor: Colors.transparent,
                elevation: 0,
                child: const Icon(Icons.chat),
              ),
            ),
          ),
          // Position the add button on the RIGHT side
          Positioned(
            right: 20,
            bottom: 0,
            child: Container(
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
                heroTag: "add_button",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AddMealsScreen()),
                  ).then((_) {
                    _loadUserData();
                  });
                },
                backgroundColor: Colors.transparent,
                elevation: 0,
                child: const Icon(Icons.add),
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: _isLoading
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
                  GestureDetector(
                    onTap: _uploadProfileImage,
                    child: Stack(
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
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              size: 12,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 25),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            _getFormattedDateTime(),
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
                            "Track your meals and stay healthy!",
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

  String _getFormattedDateTime() {
    final now = DateTime.now();
    return "${now.day}/${now.month}/${now.year}";
  }

  // Today's Meals - with navigation to detail screen
  Widget buildTodaysMeal() {
    if (userSelectedFoods.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(8.0),
        child: Text(
          "No meals found today",
          style: TextStyle(fontSize: 16, color: Colors.black54),
        ),
      );
    }

    int meal1Count = todayMealsCount['Meal 1'] ?? 0;
    int meal2Count = todayMealsCount['Meal 2'] ?? 0;
    int meal3Count = todayMealsCount['Meal 3'] ?? 0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6),
      child: Column(
        children: [
          CustomListTile(
            title: "Meal 1",
            leading: Image.asset(
              "assets/images/rectangle.png",
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
            subtitle: "$meal1Count food${meal1Count != 1 ? 's' : ''} selected",
            trailing: IconButton(
              onPressed: () {
                _navigateToMealDetail("Meal 1");
              },
              icon: const Icon(Icons.arrow_forward_ios),
            ),
            tileColor: const Color(0xFFFAFAFA),
          ),
          const SizedBox(height: 8),
          CustomListTile(
            title: "Meal 2",
            leading: Image.asset(
              "assets/images/rectangle.png",
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
            subtitle: "$meal2Count food${meal2Count != 1 ? 's' : ''} selected",
            trailing: IconButton(
              onPressed: () {
                _navigateToMealDetail("Meal 2");
              },
              icon: const Icon(Icons.arrow_forward_ios),
            ),
            tileColor: const Color(0xFFFAFAFA),
          ),
          const SizedBox(height: 8),
          if (meal3Count > 0)
            CustomListTile(
              title: "Meal 3",
              leading: Image.asset(
                "assets/images/rectangle.png",
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
              subtitle: "$meal3Count food${meal3Count != 1 ? 's' : ''} selected",
              trailing: IconButton(
                onPressed: () {
                  _navigateToMealDetail("Meal 3");
                },
                icon: const Icon(Icons.arrow_forward_ios),
              ),
              tileColor: const Color(0xFFFAFAFA),
            ),
        ],
      ),
    );
  }

  void _navigateToMealDetail(String mealType) {
    List<Map<String, dynamic>> meals = todayMealsDetails[mealType] ?? [];

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MealDetailScreen(
          mealType: mealType,
          meals: meals,
          totalCalories: meals.fold(0, (sum, meal) => sum + (meal['totalCalories'] as int)),
          totalItems: meals.length,
        ),
      ),
    );
  }

  // Cheat Meals - foods with calories > 500 per serving consumed today
  Widget buildCheatMeal() {
    if (userSelectedFoods.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(8.0),
        child: Text(
          "No cheat meals found",
          style: TextStyle(fontSize: 16, color: Colors.black54),
        ),
      );
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Get today's cheat meals
    List<Map<String, dynamic>> cheatFoods = [];

    for (var food in userSelectedFoods) {
      bool isToday = false;

      if (food.containsKey('consumptions') && food['consumptions'] != null && food['consumptions'].isNotEmpty) {
        List<dynamic> consumptions = food['consumptions'];

        for (var consumption in consumptions) {
          Map<String, dynamic> consMap = Map<String, dynamic>.from(consumption);

          // Get the date from consumption
          String dateStr = consMap['date'] ?? '';
          DateTime consumptionDate = DateTime.tryParse(dateStr) ?? DateTime.now();
          DateTime consumptionDateOnly = DateTime(consumptionDate.year, consumptionDate.month, consumptionDate.day);

          if (consumptionDateOnly == today) {
            isToday = true;
            break;
          }
        }
      }

      // Check if it's a high calorie food (> 500 kcal)
      int calories = 0;
      if (food.containsKey('calories')) {
        calories = int.tryParse(food['calories'].toString()) ?? 0;
      }

      if (isToday && calories > 500) {
        cheatFoods.add(food);
      }
    }

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
          String foodName = food['foodName'] ?? 'Unknown';
          String calories = food['calories'] ?? '0';
          String foodImageUrl = food['foodImageUrl'] ?? '';

          return CustomListTile(
            title: foodName,
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: foodImageUrl.isNotEmpty
                  ? Image.network(
                foodImageUrl,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 60,
                    height: 60,
                    color: Colors.grey[200],
                    child: const Icon(Icons.food_bank),
                  );
                },
              )
                  : Container(
                width: 60,
                height: 60,
                color: Colors.grey[200],
                child: const Icon(Icons.food_bank),
              ),
            ),
            subtitle: "$calories kcal per serving",
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

  // Calories Graph - Shows today's actual calorie consumption
  Padding buildCaloriesGraph(Size screenSize) {
    double containerHeight = screenSize.height * 0.32;
    if (containerHeight > 320) containerHeight = 320;

    // Calculate percentage of daily goal
    double percentage = (todayTotalCalories / todayGoalCalories) * 100;
    if (percentage > 100) percentage = 100;

    // Determine color based on percentage
    Color gaugeColor = const Color(0xFF00B712);
    if (percentage > 80) {
      gaugeColor = Colors.orange;
    }
    if (todayTotalCalories > todayGoalCalories) {
      gaugeColor = Colors.red;
    }

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
                        maximum: todayGoalCalories.toDouble(),
                        showLabels: false,
                        showTicks: false,
                        startAngle: 180,
                        endAngle: 0,
                        radiusFactor: 2.5,
                        ranges: [
                          GaugeRange(
                            startValue: 0,
                            endValue: todayTotalCalories.toDouble(),
                            gradient: SweepGradient(
                              colors: [const Color(0xFF5AFF15), gaugeColor],
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
                                    "$todayTotalCalories / $todayGoalCalories",
                                    style: TextStyle(
                                      fontSize: constraints.maxHeight * 0.06,
                                      color: Colors.black54,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  if (todayTotalCalories > todayGoalCalories)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: Text(
                                        "⚠️ Exceeded limit!",
                                        style: TextStyle(
                                          fontSize: constraints.maxHeight * 0.05,
                                          color: Colors.red,
                                          fontWeight: FontWeight.w500,
                                        ),
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