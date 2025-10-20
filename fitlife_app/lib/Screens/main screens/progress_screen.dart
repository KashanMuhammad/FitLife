import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../custom widgets/custom_painter.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  String selectedFilter = "All";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundImage: AssetImage("assets/images/Male.png"),
                    ),
                    SizedBox(width: 50),
                    Text(
                      "Weight Progress",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 25),
                buildProgressCard(),
                SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    buildFilterButton("All"),
                    buildFilterButton("1W"),
                    buildFilterButton("1M"),
                    buildFilterButton("6M"),
                    buildFilterButton("1Y"),
                  ],
                ),
                SizedBox(height: 24),
                SizedBox(height: 200, child: WeightProgressChart()),
                SizedBox(height: 24),
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "70",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text("kg", style: TextStyle(color: Colors.grey)),
                          SizedBox(height: 4),
                          Text("Goal Weight"),
                          SizedBox(height: 8),
                          SizedBox(
                            width: 100,
                            child: LinearProgressIndicator(
                              value: 0.7,
                              minHeight: 6,
                              backgroundColor: Colors.grey.shade300,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.green,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            "9w",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text("left"),
                        ],
                      ),
                      Container(
                        height: 60,
                        width: 1,
                        color: Colors.grey.shade400,
                        margin: EdgeInsets.symmetric(horizontal: 12),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "80",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text("kg", style: TextStyle(color: Colors.grey)),
                          SizedBox(height: 4),
                          Text("Current Weight"),
                          SizedBox(height: 8),
                          SizedBox(
                            width: 100,
                            child: LinearProgressIndicator(
                              value: 0.85,
                              minHeight: 6,
                              backgroundColor: Colors.grey.shade300,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.green,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24),
                Text(
                  "Body Mass Index",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 12),
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.fitness_center, size: 28),
                          SizedBox(width: 12),
                          Text(
                            "BMI Score",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Spacer(),
                          Text(
                            "21.02",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Text("Normal"),
                          Icon(Icons.arrow_drop_down, color: Colors.green),
                        ],
                      ),
                      SizedBox(height: 12),
                      Stack(
                        children: [
                          Container(
                            height: 8,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.green,
                                  Colors.yellow,
                                  Colors.orange,
                                  Colors.red,
                                ],
                                stops: [0.15, 0.25, 0.3, 0.4],
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          Positioned(
                            left: 130,
                            child: Icon(
                              Icons.arrow_drop_down,
                              color: Colors.green,
                              size: 28,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("15"),
                          Text("18"),
                          Text("25"),
                          Text("30"),
                          Text("35"),
                          Text("40"),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container buildProgressCard() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFFE9FDE3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          SizedBox(
            height: 140,
            width: 140,
            child: CustomPaint(
              foregroundPainter: ArcProgressPainter(0.85),
              child: Center(
                child: Text(
                  "85%",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "You are going to reach your goal by",
                  style: TextStyle(fontSize: 14, color: Colors.black87),
                ),
                SizedBox(height: 4),
                Text(
                  "05 Dec 2025",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildFilterButton(String label) {
    final bool isSelected = label == selectedFilter;

    return InkWell(
      onTap: () {
        setState(() {
          selectedFilter = label;
        });
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFF00B712) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black54,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class WeightProgressChart extends StatefulWidget {
  @override
  State<WeightProgressChart> createState() => _WeightProgressChartState();
}

class _WeightProgressChartState extends State<WeightProgressChart> {
  final List<FlSpot> spots = [
    FlSpot(0, 90),
    FlSpot(1, 95),
    FlSpot(2, 88),
    FlSpot(3, 85),
    FlSpot(4, 80),
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        LineChart(
          LineChartData(
            minX: 0,
            maxX: 4,
            minY: 70,
            maxY: 100,
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: true,
                color: Colors.orangeAccent,
                barWidth: 3,
                belowBarData: BarAreaData(
                  show: true,
                  color: Colors.orangeAccent.withOpacity(0.3),
                ),
                dotData: FlDotData(
                  show: true,
                  getDotPainter: (spot, percent, barData, index) {
                    return FlDotCirclePainter(
                      radius: 4,
                      color: Colors.white,
                      strokeWidth: 2,
                      strokeColor: Colors.orangeAccent,
                    );
                  },
                ),
              ),
            ],
            titlesData: FlTitlesData(show: false),
            gridData: FlGridData(show: false),
            borderData: FlBorderData(show: false),
          ),
        ),
        ...spots.map((spot) {
          return Positioned(
            left: (spot.x / 4) * MediaQuery.of(context).size.width * 0.8,
            top: ((100 - spot.y) / 30) * 200 - 16,
            child: Text(
              "${spot.y.toInt()} kg",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          );
        }).toList(),
      ],
    );
  }
}
