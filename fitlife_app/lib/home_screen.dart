
import 'package:fitlife_app/custom%20widgets/custom_list_tile.dart';
import 'package:fitlife_app/custom%20widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class HomeScreen extends ConsumerWidget {
   HomeScreen({super.key});

  final List<String> todaysMeal = ['Bred', 'Lunch', 'Dinner'];

  final List<String> cheatMeal = ['Checken Thi'];

  final List<String> activity = ['Football', 'Cricket'];

  final List<String> fasting = ['Fasting'];

  String getGreeting() {
    final hour = DateTime.now().hour;

    if (hour >= 5 && hour < 12) {
      return 'Good Morning';
    } else if (hour >= 12 && hour < 17) {
      return 'Good Afternoon';
    } else if (hour >= 17 && hour < 21) {
      return 'Good Evening';
    } else {
      return 'Good Night';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
   // final userAsync= ref.watch();
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      floatingActionButton: Container(
        height: 56,
        width: 56,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: LinearGradient(
            colors: [Color(0xFF5AFF15), Color(0xFF00B712)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: FloatingActionButton(
          onPressed: () {},
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Icon(Icons.add),
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.all(27),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Remove this line: SizedBox(height: 35), (It's incorrectly placed)
                  CircleAvatar(
                    radius: 24,
                    child: Image.asset("assets/images/Male.png"),
                  ),
                  SizedBox(width: 25),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            DateTime.now().toString(),
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        ),
                        SizedBox(height: 10),
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                               getGreeting(),
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 8),
                              SvgPicture.asset("assets/images/hand.svg"),
                            ],
                          ),
                        ),
                        SizedBox(height: 5),
                        Center(
                          child: Text(
                            "You lose 500 g Today,Reach Your goal soon!",
                            style: TextStyle(fontSize: 14, color: Colors.black),
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
                      gradient: LinearGradient(
                        colors: [Color(0xFF5AFF15), Color(0xFF00B712)],
                      ),
                    ),
                    child: IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.notifications_outlined),
                    ),
                  ),
                ],
              ),
            ),
            buildCaloriesGraph(screenSize),
            SizedBox(height: 10),
            CustomText(text: "Today's Meal"),
            buildTodaysMeal(),
            CustomText(text: "Cheat Meal"),
            buildCheatMeal(),
            CustomText(text: "Activity"),
            buildActivity(),
            CustomText(text: "Fasting"),
            buildFasting(),
            SizedBox(height: 80),
            // Add spacing so last item isn't hidden behind FAB
          ],
        ),
      ),
    );
  }

  Padding buildFasting() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: fasting.length,
        itemBuilder: (context, index) {
          return CustomListTile(
            title: fasting[index],
            leading: Image.asset("assets/images/rectangle.png"),
            subtitle: "12 hrs",
            trailing: IconButton(
              onPressed: () {},
              icon: Icon(Icons.arrow_forward_ios),
            ),
            tileColor: Color(0xFFFAFAFA),
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
        physics: NeverScrollableScrollPhysics(),
        itemCount: activity.length,
        itemBuilder: (context, index) {
          return CustomListTile(
            title: activity[index],
            leading: Image.asset("assets/images/rectangle.png"),
            subtitle: "-250 kcl   20 mins",
            trailing: IconButton(
              onPressed: () {},
              icon: Icon(Icons.arrow_forward_ios),
            ),
            tileColor: Color(0xFFFAFAFA),
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
        physics: NeverScrollableScrollPhysics(),
        itemCount: cheatMeal.length,
        itemBuilder: (context, index) {
          return CustomListTile(
            title: cheatMeal[index],
            leading: Image.asset("assets/images/rectangle.png"),
            subtitle: "3 Foods of  365 kcl",
            trailing: IconButton(
              onPressed: () {},
              icon: Icon(Icons.arrow_forward_ios),
            ),
            tileColor: Color(0xFFFAFAFA),
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
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return CustomListTile(
            title: todaysMeal[index],
            leading: Image.asset("assets/images/rectangle.png"),
            subtitle: "3 Foods of  365 kcl",
            onTap: () {},
            trailing: IconButton(
              onPressed: () {},
              icon: Icon(Icons.arrow_forward_ios),
            ),
            tileColor: Color(0xFFFAFAFA),
          );
        },
      ),
    );
  }

  Padding buildCaloriesGraph(Size screenSize) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: screenSize.height * 0.30,
        width: screenSize.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Color(0xFFE9FDE3),
        ),
        child: Column(
          children: [
            SizedBox(height: 100),
            Expanded(
              child: SfRadialGauge(
                axes: <RadialAxis>[
                  RadialAxis(
                    axisLineStyle: AxisLineStyle(
                      cornerStyle: CornerStyle.bothCurve,
                      thickness: 12,
                    ),
                    minimum: 0,
                    maximum: 4000,
                    showLabels: false,
                    showTicks: false,
                    startAngle: 180,
                    endAngle: 0,
                    radiusFactor:  2.5,

                    ranges: <GaugeRange>[
                      GaugeRange(
                        startValue: 0,
                        endValue: 2000,
                        gradient: SweepGradient(
                          colors: [Color(0xFF5AFF15), Color(0xFF00B712)],
                        ),
                        startWidth: 12,
                        endWidth: 12,
                      ),
                    ],
                    annotations: <GaugeAnnotation>[
                      GaugeAnnotation(
                        widget: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              "assets/images/Fire.png",
                              height: 65,
                              width: 65,
                            ),
                            SizedBox(height: 8),
                            Text("Calories"),
                            Text('1200 kcal'),
                          ],
                        ),
                        angle: 90,
                        positionFactor: 0,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
