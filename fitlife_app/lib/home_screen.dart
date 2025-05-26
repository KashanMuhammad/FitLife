import 'package:fitlife_app/custom%20widgets/custom_list_tile.dart';
import 'package:fitlife_app/custom%20widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeTabContentState();
}

class _HomeTabContentState extends State<HomeScreen> {
  final List<String> todaysMeal = ['Bred', 'Lunch', 'Dinner'];
  final List<String> cheatMeal = ['Checken Thi'];
  final List<String> activity = ['Football', 'Cricket'];
  final List<String> fasting = ['Fasting'];

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return  Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: screenSize.height * 0.4,
                  width: screenSize.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Color(0xFFE9FDE3),
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 125),
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
                              radiusFactor: 2.8,
                              ranges: <GaugeRange>[
                                GaugeRange(

                                  startValue: 0,
                                  endValue: 0,
                                  gradient: SweepGradient(
                                    colors: [
                                      Color(0xFF5AFF15),
                                      Color(0xFF00B712)
                                    ],
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
                                        height: 50,
                                        width: 50,
                                      ),
                                      SizedBox(height: 8),
                                      Text("Calories"),
                                      Text('1200 kcal'),
                                    ],
                                  ),
                                  angle: 90,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              CustomText(text: "Today's Meal"),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  itemCount: todaysMeal.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return CustomListTile(
                      title: todaysMeal[index],
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
              ),
              CustomText(text: "Cheat Meal"),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: cheatMeal.length,
                  itemBuilder: (context, index) {
                    return CustomListTile(
                      title: cheatMeal[index],
                      subtitle: "3 Foods of  365 kcl",
                      trailing: IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.arrow_forward_ios),
                      ),
                      tileColor: Color(0xFFFAFAFA),
                    );
                  },
                ),
              ),
              CustomText(text: "Activity"),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: activity.length,
                  itemBuilder: (context, index) {
                    return CustomListTile(
                      title: activity[index],
                      subtitle: "-250 kcl   20 mins",
                      trailing: IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.arrow_forward_ios),
                      ),
                      tileColor: Color(0xFFFAFAFA),
                    );
                  },
                ),
              ),
              CustomText(text: "Fasting"),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: fasting.length,
                  itemBuilder: (context, index) {
                    return CustomListTile(
                      title: fasting[index],
                      subtitle: "12 hrs",
                      trailing: IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.arrow_forward_ios),
                      ),
                      tileColor: Color(0xFFFAFAFA),
                    );
                  },
                ),
              ),
              SizedBox(height: 80), // Add spacing so last item isn't hidden behind FAB
            ],
          ),
        ),

        // FAB fixed at bottom right
        Positioned(
          bottom: 20,
          right: 20,
          child: FloatingActionButton(
            onPressed: () {
              // Your FAB action
            },
            backgroundColor:  Color(0xFF00B712),
            child: Icon(Icons.add),
          ),
        ),
      ],
    );
  }
}
