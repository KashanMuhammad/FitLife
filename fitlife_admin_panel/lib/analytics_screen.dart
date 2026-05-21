// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';
//
// class AnalyticsScreen extends StatefulWidget {
//   const AnalyticsScreen({super.key});
//
//   @override
//   State<AnalyticsScreen> createState() => _AnalyticsScreenState();
// }
//
// class _AnalyticsScreenState extends State<AnalyticsScreen> {
//   int selectedToggleIndex = 0;
//   String selectedFilter = "All Date";
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Header
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   const Text(
//                     "Analytics",
//                     style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
//                   ),
//                   Row(
//                     children: const [
//                       Text(
//                         "Cody Fisher\nDashboard Manager",
//                         textAlign: TextAlign.right,
//                         style: TextStyle(fontSize: 14),
//                       ),
//                       SizedBox(width: 10),
//                       CircleAvatar(
//                         radius: 24,
//                         backgroundImage: AssetImage("assets/male avatar.png"),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 20),
//
//               // Welcome Section
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   const Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "Welcome Cody Fisher",
//                         style: TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       Text("Lorem ipsum dolor sit amet welcome back Johny"),
//                     ],
//                   ),
//
//                   // Toggle Buttons
//                   Row(
//                     children: [
//                       Container(
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: ToggleButtons(
//                           isSelected: [
//                             selectedToggleIndex == 0,
//                             selectedToggleIndex == 1,
//                             selectedToggleIndex == 2,
//                             selectedToggleIndex == 3,
//                             selectedToggleIndex == 4,
//                           ],
//                           onPressed: (index) {
//                             setState(() {
//                               selectedToggleIndex = index;
//                             });
//                           },
//                           fillColor: Colors.transparent,
//                           splashColor: Colors.transparent,
//                           highlightColor: Colors.transparent,
//                           hoverColor: Colors.transparent,
//                           borderColor: Colors.transparent,
//                           selectedColor: Colors.white,
//                           color: Colors.green.shade900,
//                           borderRadius: BorderRadius.circular(8),
//                           renderBorder: false,
//                           children: [
//                             _buildToggleButton(
//                               "All Date",
//                               selectedToggleIndex == 0,
//                             ),
//                             _buildToggleButton(
//                               "24 Hour",
//                               selectedToggleIndex == 1,
//                             ),
//                             _buildToggleButton(
//                               "7 Days",
//                               selectedToggleIndex == 2,
//                             ),
//                             _buildToggleButton(
//                               "30 Days",
//                               selectedToggleIndex == 3,
//                             ),
//                             _buildToggleButton(
//                               "12 Months",
//                               selectedToggleIndex == 4,
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 20),
//
//               // Stats Cards
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: const [
//                   StatCard(
//                     title: "New Users",
//                     value: "256.00k",
//                     change: "+150 today",
//                     percent: "10%",
//                     isIncrease: true,
//                   ),
//                   StatCard(
//                     title: "Active Users",
//                     value: "156.00k",
//                     change: "+150 today",
//                     percent: "20%",
//                     isIncrease: false,
//                   ),
//                   StatCard(
//                     title: "Non-Active Users",
//                     value: "016.10k",
//                     change: "+150 today",
//                     percent: "10%",
//                     isIncrease: true,
//                   ),
//                   StatCard(
//                     title: "Total Users",
//                     value: "400.00k",
//                     change: "+150 today",
//                     percent: "10%",
//                     isIncrease: true,
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 30),
//
//               // Line Chart with 12 months
//               Card(
//                 elevation: 3,
//                 child: Padding(
//                   padding: const EdgeInsets.all(20),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         "Total Users",
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 20),
//                       SizedBox(
//                         height: MediaQuery.of(context).size.height * 0.7,
//                         child: const UserLineChart(),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class StatCard extends StatelessWidget {
//   final String title;
//   final String value;
//   final String percent;
//   final String change;
//   final bool isIncrease;
//
//   const StatCard({
//     super.key,
//     required this.title,
//     required this.value,
//     required this.percent,
//     required this.change,
//     required this.isIncrease,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: Card(
//         elevation: 3,
//         child: Padding(
//           padding: const EdgeInsets.all(15),
//           child: Column(
//             children: [
//               Text(
//                 title,
//                 style: const TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//               const SizedBox(height: 10),
//               Text(
//                 value,
//                 style: const TextStyle(
//                   fontSize: 22,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 10),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(
//                     isIncrease ? Icons.arrow_upward : Icons.arrow_downward,
//                     color: isIncrease ? Colors.green : Colors.red,
//                     size: 16,
//                   ),
//                   Text(
//                     percent,
//                     style: TextStyle(
//                       color: isIncrease ? Colors.green : Colors.red,
//                     ),
//                   ),
//                   const SizedBox(width: 5),
//                   Text(change, style: const TextStyle(color: Colors.grey)),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class UserLineChart extends StatelessWidget {
//   const UserLineChart({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return LineChart(
//       LineChartData(
//         minX: 0,
//         maxX: 11,
//         // Changed from 6 to 11 for 12 months (0-11)
//         minY: 0,
//         maxY: 35000,
//
//         gridData: const FlGridData(show: false),
//         borderData: FlBorderData(show: false),
//
//         titlesData: FlTitlesData(
//           topTitles: const AxisTitles(
//             sideTitles: SideTitles(showTitles: false),
//           ),
//           rightTitles: const AxisTitles(
//             sideTitles: SideTitles(showTitles: false),
//           ),
//
//           leftTitles: AxisTitles(
//             sideTitles: SideTitles(
//               showTitles: true,
//               interval: 10000,
//               reservedSize: 40,
//               getTitlesWidget: (value, meta) {
//                 if (value == 0) return const Text("0");
//                 if (value == 10000) return const Text("10K");
//                 if (value == 20000) return const Text("20K");
//                 if (value == 30000) return const Text("30K");
//                 return const SizedBox();
//               },
//             ),
//           ),
//
//           bottomTitles: AxisTitles(
//             sideTitles: SideTitles(
//               showTitles: true,
//               reservedSize: 40,
//               interval: 1, // Show every month
//               getTitlesWidget: (value, meta) {
//                 const months = [
//                   "Jan",
//                   "Feb",
//                   "Mar",
//                   "Apr",
//                   "May",
//                   "Jun",
//                   "Jul",
//                   "Aug",
//                   "Sep",
//                   "Oct",
//                   "Nov",
//                   "Dec",
//                 ];
//
//                 if (value.toInt() >= 0 && value.toInt() < months.length) {
//                   // Show every other month on smaller screens to prevent overcrowding
//                   if (MediaQuery.of(context).size.width < 600 &&
//                       value.toInt() % 2 != 0) {
//                     return const SizedBox();
//                   }
//
//                   return Padding(
//                     padding: const EdgeInsets.only(top: 8),
//                     child: Text(
//                       months[value.toInt()],
//                       style: const TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   );
//                 }
//                 return const Text("");
//               },
//             ),
//           ),
//         ),
//
//         lineBarsData: [
//           // THIS YEAR (Green Solid) - Updated with 12 months of data
//           LineChartBarData(
//             spots: const [
//               FlSpot(0, 12000), // Jan
//               FlSpot(1, 8000), // Feb
//               FlSpot(2, 14000), // Mar
//               FlSpot(3, 25000), // Apr
//               FlSpot(4, 30000), // May
//               FlSpot(5, 21000), // Jun
//               FlSpot(6, 24000), // Jul
//               FlSpot(7, 28000), // Aug
//               FlSpot(8, 22000), // Sep
//               FlSpot(9, 19000), // Oct
//               FlSpot(10, 26000), // Nov
//               FlSpot(11, 32000), // Dec
//             ],
//             isCurved: true,
//             color: Colors.green,
//             barWidth: 3,
//             dotData: const FlDotData(show: false),
//           ),
//
//           // LAST YEAR (Blue Dotted) - Updated with 12 months of data
//           LineChartBarData(
//             spots: const [
//               FlSpot(0, 5000), // Jan
//               FlSpot(1, 12000), // Feb
//               FlSpot(2, 21000), // Mar
//               FlSpot(3, 7000), // Apr
//               FlSpot(4, 15000), // May
//               FlSpot(5, 23000), // Jun
//               FlSpot(6, 31000), // Jul
//               FlSpot(7, 18000), // Aug
//               FlSpot(8, 14000), // Sep
//               FlSpot(9, 27000), // Oct
//               FlSpot(10, 20000), // Nov
//               FlSpot(11, 29000), // Dec
//             ],
//             isCurved: true,
//             color: Colors.blueGrey,
//             barWidth: 2,
//             dashArray: [5, 5],
//             dotData: const FlDotData(show: false),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// Widget _buildToggleButton(String text, bool selected) {
//   return Container(
//     padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
//     decoration: BoxDecoration(
//       gradient:
//           selected
//               ? const LinearGradient(
//                 colors: [Color(0xFF5AFF15), Color(0xFF00B712)],
//               )
//               : null,
//       color: selected ? null : Colors.grey.shade100,
//       borderRadius: BorderRadius.circular(8),
//     ),
//     child: Text(
//       text,
//       style: TextStyle(
//         fontWeight: FontWeight.bold,
//         color: selected ? Colors.white : Colors.black,
//       ),
//     ),
//   );
// }




import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import 'admin_provider.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  int selectedToggleIndex = 0;
  String selectedFilter = "All Date";

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Analytics data
  int newUsers = 0;
  int activeUsers = 0;
  int nonActiveUsers = 0;
  int totalUsers = 0;

  // Chart data
  List<FlSpot> thisYearSpots = [];
  List<FlSpot> lastYearSpots = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAnalyticsData();
  }

  Future<void> fetchAnalyticsData() async {
    setState(() {
      isLoading = true;
    });

    try {
      DateTime now = DateTime.now();
      DateTime startDate;

      switch (selectedToggleIndex) {
        case 0: // All Date
          await fetchAllDateData();
          break;
        case 1: // 24 Hour
          startDate = now.subtract(const Duration(hours: 24));
          await fetchTimeRangeData(startDate, now);
          break;
        case 2: // 7 Days
          startDate = now.subtract(const Duration(days: 7));
          await fetchTimeRangeData(startDate, now);
          break;
        case 3: // 30 Days
          startDate = now.subtract(const Duration(days: 30));
          await fetchTimeRangeData(startDate, now);
          break;
        case 4: // 12 Months
          startDate = DateTime(now.year - 1, now.month, now.day);
          await fetchTimeRangeData(startDate, now);
          break;
      }

      // Fetch chart data for all time monthly comparison
      await fetchChartData();

    } catch (e) {
      debugPrint("Error fetching analytics: $e");
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> fetchAllDateData() async {
    try {
      QuerySnapshot usersSnapshot = await firestore.collection("Users").get();
      int totalUserCount = usersSnapshot.docs.length;

      setState(() {
        totalUsers = totalUserCount;
        newUsers = totalUserCount;
        activeUsers = totalUserCount;
        nonActiveUsers = 0;
      });

    } catch (e) {
      debugPrint("Error fetching all date data: $e");
    }
  }

  Future<void> fetchTimeRangeData(DateTime startDate, DateTime endDate) async {
    try {
      QuerySnapshot usersSnapshot = await firestore.collection("Users").get();
      int totalUserCount = usersSnapshot.docs.length;

      int activeCount = 0;
      int newCount = 0;

      for (var doc in usersSnapshot.docs) {
        // Check if user is ACTIVE (has logged in/had activity during the time period)
        // Using supportTimestamp as last activity/login time
        Timestamp? lastActivity = doc["supportTimestamp"];

        if (lastActivity != null) {
          DateTime activityDate = lastActivity.toDate();
          if (activityDate.isAfter(startDate) && activityDate.isBefore(endDate)) {
            activeCount++;
          }
        }

        // Check if user is NEW (signed up during the time period)
        Timestamp? createdAt = doc["supportTimestamp"];
        if (createdAt != null) {
          DateTime createdDate = createdAt.toDate();
          if (createdDate.isAfter(startDate) && createdDate.isBefore(endDate)) {
            newCount++;
          }
        }
      }

      // Calculate NON-ACTIVE users: Total users - Active users (who logged in during the period)
      int nonActiveCount = totalUserCount - activeCount;

      setState(() {
        totalUsers = totalUserCount;
        newUsers = newCount;
        activeUsers = activeCount;
        nonActiveUsers = nonActiveCount;
      });

    } catch (e) {
      debugPrint("Error fetching time range data: $e");
    }
  }

  Future<void> fetchChartData() async {
    try {
      QuerySnapshot usersSnapshot = await firestore.collection("Users").get();

      List<double> thisYearMonthlyData = List.filled(12, 0.0);
      List<double> lastYearMonthlyData = List.filled(12, 0.0);

      DateTime now = DateTime.now();
      int currentYear = now.year;
      int lastYear = currentYear - 1;

      for (var doc in usersSnapshot.docs) {
        Timestamp? createdAt = doc["supportTimestamp"];

        if (createdAt != null) {
          DateTime createdDate = createdAt.toDate();
          int year = createdDate.year;
          int month = createdDate.month - 1;

          if (year == currentYear) {
            thisYearMonthlyData[month]++;
          } else if (year == lastYear) {
            lastYearMonthlyData[month]++;
          }
        }
      }

      List<FlSpot> thisYearSpotsTemp = [];
      List<FlSpot> lastYearSpotsTemp = [];

      for (int i = 0; i < 12; i++) {
        thisYearSpotsTemp.add(FlSpot(i.toDouble(), thisYearMonthlyData[i]));
        lastYearSpotsTemp.add(FlSpot(i.toDouble(), lastYearMonthlyData[i]));
      }

      setState(() {
        thisYearSpots = thisYearSpotsTemp;
        lastYearSpots = lastYearSpotsTemp;
      });

    } catch (e) {
      debugPrint("Error fetching chart data: $e");
    }
  }

  String formatNumber(int number) {
    if (number >= 1000) {
      return "${(number / 1000).toStringAsFixed(2)}k";
    }
    return number.toString().padLeft(2, '0');
  }

  String getPercentChange(int value, int total) {
    if (total == 0) return "0%";
    double percent = (value / total) * 100;
    return "${percent.toStringAsFixed(0)}%";
  }

  @override
  Widget build(BuildContext context) {
    String adminName = Provider.of<AdminProvider>(context).adminName;
    return Scaffold(
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Analytics",
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children:  [
                      Text(
                        "$adminName\nDashboard Manager",
                        textAlign: TextAlign.right,
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(width: 10),
                      CircleAvatar(
                        radius: 24,
                        backgroundImage: AssetImage("assets/male avatar.png"),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Welcome Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Welcome $adminName",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text("Lorem ipsum dolor sit amet welcome back Johny"),
                    ],
                  ),

                  // Toggle Buttons
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ToggleButtons(
                          isSelected: [
                            selectedToggleIndex == 0,
                            selectedToggleIndex == 1,
                            selectedToggleIndex == 2,
                            selectedToggleIndex == 3,
                            selectedToggleIndex == 4,
                          ],
                          onPressed: (index) {
                            setState(() {
                              selectedToggleIndex = index;
                            });
                            fetchAnalyticsData();
                          },
                          fillColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          borderColor: Colors.transparent,
                          selectedColor: Colors.white,
                          color: Colors.green.shade900,
                          borderRadius: BorderRadius.circular(8),
                          renderBorder: false,
                          children: [
                            _buildToggleButton(
                              "All Date",
                              selectedToggleIndex == 0,
                            ),
                            _buildToggleButton(
                              "24 Hour",
                              selectedToggleIndex == 1,
                            ),
                            _buildToggleButton(
                              "7 Days",
                              selectedToggleIndex == 2,
                            ),
                            _buildToggleButton(
                              "30 Days",
                              selectedToggleIndex == 3,
                            ),
                            _buildToggleButton(
                              "12 Months",
                              selectedToggleIndex == 4,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Stats Cards
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  StatCard(
                    title: "New Users",
                    value: formatNumber(newUsers),
                    change: "${newUsers} users",
                    percent: getPercentChange(newUsers, totalUsers),
                    isIncrease: true,
                  ),
                  StatCard(
                    title: "Active Users",
                    value: formatNumber(activeUsers),
                    change: "${activeUsers} users",
                    percent: getPercentChange(activeUsers, totalUsers),
                    isIncrease: true,
                  ),
                  StatCard(
                    title: "Non-Active Users",
                    value: formatNumber(nonActiveUsers),
                    change: "${nonActiveUsers} users",
                    percent: getPercentChange(nonActiveUsers, totalUsers),
                    isIncrease: nonActiveUsers > 0,
                  ),
                  StatCard(
                    title: "Total Users",
                    value: formatNumber(totalUsers),
                    change: "${totalUsers} total",
                    percent: "100%",
                    isIncrease: true,
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Line Chart with 12 months
              Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Total Users",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.7,
                        child: UserLineChart(
                          thisYearSpots: thisYearSpots,
                          lastYearSpots: lastYearSpots,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String percent;
  final String change;
  final bool isIncrease;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.percent,
    required this.change,
    required this.isIncrease,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isIncrease ? Icons.arrow_upward : Icons.arrow_downward,
                    color: isIncrease ? Colors.green : Colors.red,
                    size: 16,
                  ),
                  Text(
                    percent,
                    style: TextStyle(
                      color: isIncrease ? Colors.green : Colors.red,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(change, style: const TextStyle(color: Colors.grey)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UserLineChart extends StatelessWidget {
  final List<FlSpot> thisYearSpots;
  final List<FlSpot> lastYearSpots;

  const UserLineChart({
    super.key,
    required this.thisYearSpots,
    required this.lastYearSpots,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate max Y value from data or use default
    double maxY = 100;
    for (var spot in thisYearSpots) {
      if (spot.y > maxY) maxY = spot.y;
    }
    for (var spot in lastYearSpots) {
      if (spot.y > maxY) maxY = spot.y;
    }
    maxY = maxY == 0 ? 100 : maxY * 1.1;

    return LineChart(
      LineChartData(
        minX: 0,
        maxX: 11,
        minY: 0,
        maxY: maxY,

        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),

        titlesData: FlTitlesData(
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),

          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                if (value == 0) return const Text("0");
                if (value >= 1000) {
                  return Text("${(value / 1000).toStringAsFixed(0)}K");
                }
                return Text(value.toStringAsFixed(0));
              },
            ),
          ),

          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              interval: 1,
              getTitlesWidget: (value, meta) {
                const months = [
                  "Jan",
                  "Feb",
                  "Mar",
                  "Apr",
                  "May",
                  "Jun",
                  "Jul",
                  "Aug",
                  "Sep",
                  "Oct",
                  "Nov",
                  "Dec",
                ];

                if (value.toInt() >= 0 && value.toInt() < months.length) {
                  if (MediaQuery.of(context).size.width < 600 &&
                      value.toInt() % 2 != 0) {
                    return const SizedBox();
                  }

                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      months[value.toInt()],
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }
                return const Text("");
              },
            ),
          ),
        ),

        lineBarsData: [
          // THIS YEAR (Green Solid)
          LineChartBarData(
            spots: thisYearSpots.isEmpty ? _getDefaultSpots() : thisYearSpots,
            isCurved: true,
            color: Colors.green,
            barWidth: 3,
            dotData: const FlDotData(show: false),
          ),

          // LAST YEAR (Blue Dotted)
          LineChartBarData(
            spots: lastYearSpots.isEmpty ? _getDefaultSpots() : lastYearSpots,
            isCurved: true,
            color: Colors.blueGrey,
            barWidth: 2,
            dashArray: [5, 5],
            dotData: const FlDotData(show: false),
          ),
        ],
      ),
    );
  }

  List<FlSpot> _getDefaultSpots() {
    return const [
      FlSpot(0, 0), FlSpot(1, 0), FlSpot(2, 0), FlSpot(3, 0),
      FlSpot(4, 0), FlSpot(5, 0), FlSpot(6, 0), FlSpot(7, 0),
      FlSpot(8, 0), FlSpot(9, 0), FlSpot(10, 0), FlSpot(11, 0),
    ];
  }
}

Widget _buildToggleButton(String text, bool selected) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
    decoration: BoxDecoration(
      gradient: selected
          ? const LinearGradient(
        colors: [Color(0xFF5AFF15), Color(0xFF00B712)],
      )
          : null,
      color: selected ? null : Colors.grey.shade100,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: selected ? Colors.white : Colors.black,
      ),
    ),
  );
}