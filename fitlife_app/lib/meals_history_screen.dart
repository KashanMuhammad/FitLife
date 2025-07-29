import 'package:fitlife_app/custom%20widgets/add_meals_tile.dart';
import 'package:fitlife_app/custom%20widgets/custom_list_tile.dart';
import 'package:flutter/material.dart';

class MealsHistoryScreen extends StatefulWidget {
  const MealsHistoryScreen({super.key});

  @override
  State<MealsHistoryScreen> createState() => _MealsHistoryScreenState();
}

class _MealsHistoryScreenState extends State<MealsHistoryScreen> {
  int selectedIndex = 0;
  final List<String> todaysMeal = ['Bred', 'Bred', 'Bred'];
  final List<String> yesterdayMeal = ['Bred', 'Bred', 'Bred'];
  final List<String> beforeYesterdayMeal = ['Bred', 'Bred', 'Bred'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 15),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back_ios),
                    ),
                    const SizedBox(width: 100),
                    const Text(
                      "Meals History",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(8),
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: const Color(0xFFE9FDE3),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // All Button
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedIndex = 0;
                          });
                        },
                        child: Container(
                          height: 35,
                          width: 50,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient:
                                selectedIndex == 0
                                    ? const LinearGradient(
                                      colors: [
                                        Color(0xFF5AFF15),
                                        Color(0xFF00B712),
                                      ],
                                    )
                                    : null,
                            color: selectedIndex == 0 ? null : Colors.white,
                          ),
                          child: Text(
                            "All",
                            style: TextStyle(
                              color:
                                  selectedIndex == 0
                                      ? Colors.white
                                      : Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),

                      // Breakfast Button
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedIndex = 1;
                          });
                        },
                        child: Container(
                          height: 35,
                          width: 75,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient:
                                selectedIndex == 1
                                    ? const LinearGradient(
                                      colors: [
                                        Color(0xFF5AFF15),
                                        Color(0xFF00B712),
                                      ],
                                    )
                                    : null,
                            color: selectedIndex == 1 ? null : Colors.white,
                          ),
                          child: Text(
                            "Breakfast",
                            style: TextStyle(
                              color:
                                  selectedIndex == 1
                                      ? Colors.white
                                      : Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),

                      // Lunch Button
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedIndex = 2;
                          });
                        },
                        child: Container(
                          height: 35,
                          width: 60,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient:
                                selectedIndex == 2
                                    ? const LinearGradient(
                                      colors: [
                                        Color(0xFF5AFF15),
                                        Color(0xFF00B712),
                                      ],
                                    )
                                    : null,
                            color: selectedIndex == 2 ? null : Colors.white,
                          ),
                          child: Text(
                            "Lunch",
                            style: TextStyle(
                              color:
                                  selectedIndex == 2
                                      ? Colors.white
                                      : Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedIndex = 3;
                          });
                        },
                        child: Container(
                          height: 35,
                          width: 70,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient:
                                selectedIndex == 3
                                    ? const LinearGradient(
                                      colors: [
                                        Color(0xFF5AFF15),
                                        Color(0xFF00B712),
                                      ],
                                    )
                                    : null,
                            color: selectedIndex == 3 ? null : Colors.white,
                          ),
                          child: Text(
                            "Dinner",
                            style: TextStyle(
                              color:
                                  selectedIndex == 3
                                      ? Colors.white
                                      : Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  "Today Meal",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: todaysMeal.length,
                itemBuilder: (context, index) {
                  return CustomListTile(
                    title: todaysMeal[index],
                    leading: Image.asset("assets/images/rectangle.png"),
                    subtitle: "3 foods 370 kcl",
                    trailing: IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.arrow_forward_ios),
                    ),
                    tileColor: Color(0xFFFAFAFA),
                  );
                },
              ),
            ),
                SizedBox(height: 15),
                Text(
                  "Yesterday Meal",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: yesterdayMeal.length,
                    itemBuilder: (context, index) {
                      return CustomListTile(
                        title: yesterdayMeal[index],
                        leading: Image.asset("assets/images/rectangle.png"),
                        subtitle: "3 foods 370 kcl",
                        trailing: IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.arrow_forward_ios),
                        ),
                        tileColor: Color(0xFFFAFAFA),
                      );
                    },
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  "14-9-2025 Meals",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
                
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: beforeYesterdayMeal.length,
                    itemBuilder: (context, index) {
                      return CustomListTile(
                        title: beforeYesterdayMeal[index],
                        leading: Image.asset("assets/images/rectangle.png"),
                        subtitle: "3 foods 370 kcl",
                        trailing: IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.arrow_forward_ios),
                        ),
                        tileColor: Color(0xFFFAFAFA),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
