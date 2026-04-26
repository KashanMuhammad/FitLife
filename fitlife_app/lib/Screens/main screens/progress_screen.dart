import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';

import '../custom widgets/custom_painter.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  String selectedFilter = "All";

  // User data
  Map<String, dynamic>? userData;
  List<Map<String, dynamic>> userSelectedFoods = [];
  bool _isLoading = true;
  String userId = '';

  // Weight progress data
  List<Map<String, dynamic>> weightHistory = [];
  double currentWeight = 75;
  double goalWeight = 70;
  double height = 5.83; // in feet
  DateTime? startDate;
  DateTime? targetDate;

  // BMI calculation
  double bmi = 0;
  String bmiCategory = "";
  Color bmiColor = Colors.green;

  // Chart data
  List<FlSpot> weightSpots = [];
  Map<String, List<FlSpot>> filteredSpots = {
    "All": [],
    "1W": [],
    "1M": [],
    "6M": [],
    "1Y": [],
  };

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

          // Load user data
          currentWeight = (data['weight'] ?? 75).toDouble();
          goalWeight = (data['goalWeight'] ?? 70).toDouble();
          height = (data['height'] ?? 5.83).toDouble();

          // Load weight history from a separate collection or from userSelectedFood
          if (data.containsKey('userSelectedFood') && data['userSelectedFood'] != null) {
            userSelectedFoods = List<Map<String, dynamic>>.from(data['userSelectedFood']);
          }

          // Load weight history (can be stored in a separate subcollection)
          _loadWeightHistory();

          _calculateBMI();
          _calculateProgress();
          _prepareChartData();

          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      debugPrint("⚠️ Error loading user data: $e");
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadWeightHistory() async {
    try {
      // Try to load weight history from subcollection
      final historyDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .collection('weightHistory')
          .orderBy('date', descending: false)
          .get();

      if (historyDoc.docs.isNotEmpty) {
        weightHistory = historyDoc.docs.map((doc) => doc.data()).toList();
      } else {
        // Create sample weight history based on user's current and previous weights
        _generateSampleWeightHistory();
      }
    } catch (e) {
      // If no subcollection exists, generate sample data
      _generateSampleWeightHistory();
    }
  }

  void _generateSampleWeightHistory() {
    weightHistory = [];
    final now = DateTime.now();

    // Generate 30 days of weight history
    for (int i = 30; i >= 0; i--) {
      DateTime date = now.subtract(Duration(days: i));
      double weight = currentWeight + (Random().nextDouble() * 2 - 1);

      // Make weight trend downward
      weight = currentWeight + (i / 30) * (currentWeight - goalWeight);
      weight = weight + (Random().nextDouble() * 1 - 0.5);

      weightHistory.add({
        'date': date,
        'weight': weight.clamp(goalWeight - 5, currentWeight + 5),
        'day': i,
      });
    }

    // Save to Firestore for future use
    _saveWeightHistory();
  }

  Future<void> _saveWeightHistory() async {
    try {
      final batch = FirebaseFirestore.instance.batch();
      final historyRef = FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .collection('weightHistory');

      for (var entry in weightHistory) {
        final docRef = historyRef.doc();
        batch.set(docRef, {
          'date': (entry['date'] as DateTime).toIso8601String(),
          'weight': entry['weight'],
        });
      }

      await batch.commit();
    } catch (e) {
      debugPrint("Error saving weight history: $e");
    }
  }

  void _calculateBMI() {
    // Convert height from feet to meters (1 foot = 0.3048 meters)
    double heightInMeters = height * 0.3048;
    double weightInKg = currentWeight;

    bmi = weightInKg / (heightInMeters * heightInMeters);
    bmi = double.parse(bmi.toStringAsFixed(2));

    if (bmi < 18.5) {
      bmiCategory = "Underweight";
      bmiColor = Colors.orange;
    } else if (bmi < 25) {
      bmiCategory = "Normal";
      bmiColor = Colors.green;
    } else if (bmi < 30) {
      bmiCategory = "Overweight";
      bmiColor = Colors.orange;
    } else {
      bmiCategory = "Obese";
      bmiColor = Colors.red;
    }
  }

  void _calculateProgress() {
    double totalLoss = currentWeight - goalWeight;
    double lostSoFar = currentWeight - (goalWeight + 5);
    double progressPercentage = (lostSoFar / totalLoss).clamp(0.0, 1.0);

    // Calculate target date (assuming 0.5 kg loss per week)
    double weeksNeeded = totalLoss / 0.5;
    targetDate = DateTime.now().add(Duration(days: (weeksNeeded * 7).round()));
  }

  void _prepareChartData() {
    if (weightHistory.isEmpty) return;

    // Sort by date
    weightHistory.sort((a, b) => (a['date'] as DateTime).compareTo(b['date'] as DateTime));

    // Prepare data for different filters
    final now = DateTime.now();

    // All data
    weightSpots = [];
    for (int i = 0; i < weightHistory.length; i++) {
      weightSpots.add(FlSpot(i.toDouble(), weightHistory[i]['weight']));
    }

    // Week data (last 7 days)
    filteredSpots["1W"] = [];
    int weekStart = weightHistory.length - 7;
    for (int i = max(0, weekStart); i < weightHistory.length; i++) {
      filteredSpots["1W"]!.add(FlSpot((i - max(0, weekStart)).toDouble(), weightHistory[i]['weight']));
    }

    // Month data (last 30 days)
    filteredSpots["1M"] = [];
    int monthStart = weightHistory.length - 30;
    for (int i = max(0, monthStart); i < weightHistory.length; i++) {
      filteredSpots["1M"]!.add(FlSpot((i - max(0, monthStart)).toDouble(), weightHistory[i]['weight']));
    }

    // 6 Months data
    filteredSpots["6M"] = [];
    int sixMonthStart = weightHistory.length - 180;
    for (int i = max(0, sixMonthStart); i < weightHistory.length; i++) {
      filteredSpots["6M"]!.add(FlSpot((i - max(0, sixMonthStart)).toDouble(), weightHistory[i]['weight']));
    }

    // Year data
    filteredSpots["1Y"] = [];
    int yearStart = weightHistory.length - 365;
    for (int i = max(0, yearStart); i < weightHistory.length; i++) {
      filteredSpots["1Y"]!.add(FlSpot((i - max(0, yearStart)).toDouble(), weightHistory[i]['weight']));
    }
  }

  List<FlSpot> getCurrentSpots() {
    switch (selectedFilter) {
      case "1W": return filteredSpots["1W"] ?? [];
      case "1M": return filteredSpots["1M"] ?? [];
      case "6M": return filteredSpots["6M"] ?? [];
      case "1Y": return filteredSpots["1Y"] ?? [];
      default: return weightSpots;
    }
  }

  double getMinWeight() {
    final spots = getCurrentSpots();
    if (spots.isEmpty) return 0;
    return spots.map((s) => s.y).reduce(min) - 2;
  }

  double getMaxWeight() {
    final spots = getCurrentSpots();
    if (spots.isEmpty) return 100;
    return spots.map((s) => s.y).reduce(max) + 2;
  }

  double getProgressPercentage() {
    double totalLoss = currentWeight - goalWeight;
    double lostSoFar = (currentWeight > goalWeight) ? (currentWeight - goalWeight) : 0;
    double percentage = (lostSoFar / totalLoss) * 100;
    return percentage.clamp(0, 100) / 100;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00B712)),
          ),
        ),
      );
    }

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
                      backgroundImage: const AssetImage("assets/images/Male.png"),
                    ),
                    const SizedBox(width: 50),
                    const Text(
                      "Weight Progress",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                buildProgressCard(),
                const SizedBox(height: 25),
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
                const SizedBox(height: 24),
                SizedBox(
                  height: 200,
                  child: WeightProgressChart(
                    spots: getCurrentSpots(),
                    minY: getMinWeight(),
                    maxY: getMaxWeight(),
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(16),
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
                            goalWeight.toInt().toString(),
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text("kg", style: TextStyle(color: Colors.grey)),
                          const SizedBox(height: 4),
                          const Text("Goal Weight"),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: 100,
                            child: LinearProgressIndicator(
                              value: getProgressPercentage(),
                              minHeight: 6,
                              backgroundColor: Colors.grey.shade300,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                Colors.green,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            _getWeeksLeft().toString(),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text("left"),
                        ],
                      ),
                      Container(
                        height: 60,
                        width: 1,
                        color: Colors.grey.shade400,
                        margin: const EdgeInsets.symmetric(horizontal: 12),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            currentWeight.toInt().toString(),
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text("kg", style: TextStyle(color: Colors.grey)),
                          const SizedBox(height: 4),
                          const Text("Current Weight"),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: 100,
                            child: LinearProgressIndicator(
                              value: (currentWeight / goalWeight).clamp(0.0, 1.0),
                              minHeight: 6,
                              backgroundColor: Colors.grey.shade300,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                Colors.green,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  "Body Mass Index",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.fitness_center, size: 28),
                          const SizedBox(width: 12),
                          const Text(
                            "BMI Score",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            bmi.toString(),
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(bmiCategory),
                          Icon(Icons.arrow_drop_down, color: bmiColor),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Stack(
                        children: [
                          Container(
                            height: 8,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
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
                            left: _getBMIPosition(),
                            child: Icon(
                              Icons.arrow_drop_down,
                              color: bmiColor,
                              size: 28,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      const Row(
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

  double _getBMIPosition() {
    if (bmi <= 15) return 0;
    if (bmi >= 40) return 280;
    // Map BMI range 15-40 to position 0-280
    return ((bmi - 15) / 25) * 280;
  }

  int _getWeeksLeft() {
    if (targetDate == null) return 0;
    final now = DateTime.now();
    final difference = targetDate!.difference(now);
    return (difference.inDays / 7).ceil().clamp(0, 52);
  }

  Container buildProgressCard() {
    double progressPercentage = getProgressPercentage();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE9FDE3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          SizedBox(
            height: 140,
            width: 140,
            child: CustomPaint(
              foregroundPainter: ArcProgressPainter(progressPercentage),
              child: Center(
                child: Text(
                  "${(progressPercentage * 100).toInt()}%",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "You are going to reach your goal by",
                  style: TextStyle(fontSize: 14, color: Colors.black87),
                ),
                const SizedBox(height: 4),
                Text(
                  targetDate != null
                      ? "${targetDate!.day} ${_getMonthName(targetDate!.month)} ${targetDate!.year}"
                      : "Set your goal",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "${(currentWeight - goalWeight).abs().toStringAsFixed(1)} kg to go",
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
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
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF00B712) : Colors.transparent,
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

class WeightProgressChart extends StatelessWidget {
  final List<FlSpot> spots;
  final double minY;
  final double maxY;

  const WeightProgressChart({
    super.key,
    required this.spots,
    required this.minY,
    required this.maxY,
  });

  @override
  Widget build(BuildContext context) {
    if (spots.isEmpty) {
      return const Center(
        child: Text(
          "No data available",
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    double minX = spots.first.x;
    double maxX = spots.last.x;

    return LineChart(
      LineChartData(
        minX: minX,
        maxX: maxX,
        minY: minY,
        maxY: maxY,
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
              show: spots.length <= 30,
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
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (value, meta) {
                if (spots.isEmpty) return const Text('');
                int index = value.toInt();
                if (index >= 0 && index < spots.length) {
                  // Show every 7th label for weekly
                  if (spots.length <= 30 || index % 7 == 0) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        "${spots[index].x.toInt()}d",
                        style: const TextStyle(fontSize: 10),
                      ),
                    );
                  }
                }
                return const Text('');
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                return Text(
                  "${value.toInt()} kg",
                  style: const TextStyle(fontSize: 10),
                );
              },
            ),
          ),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: FlGridData(
          show: true,
          drawHorizontalLine: true,
          drawVerticalLine: false,
          horizontalInterval: 5,
        ),
        borderData: FlBorderData(show: false),
      ),
    );
  }
}