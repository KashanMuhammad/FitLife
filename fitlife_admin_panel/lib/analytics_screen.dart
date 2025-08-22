import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  String selectedFilter = "All Date";

  final filters = ["All Date", "24 Hour", "7 Days", "30 Days", "12 Months"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
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
                  children: const [
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                          "https://i.pravatar.cc/150?img=3"), // demo profile
                      radius: 20,
                    ),
                    SizedBox(width: 10),
                    Text("Cody Fisher\nDashboard Manager",
                        textAlign: TextAlign.right,
                        style: TextStyle(fontSize: 14)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Welcome Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Welcome Cody Fisher",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    Text("Lorem ipsum dolor sit amet welcome back Johny"),
                  ],
                ),
                Row(
                  children: filters.map((f) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: ChoiceChip(
                        label: Text(f),
                        selected: selectedFilter == f,
                        onSelected: (_) {
                          setState(() {
                            selectedFilter = f;
                          });
                        },
                        selectedColor: Colors.green,
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Stats Cards
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                StatCard(
                  title: "New Users",
                  value: "256.00k",
                  change: "+150 today",
                  percent: "10%",
                  isIncrease: true,
                ),
                StatCard(
                  title: "Active Users",
                  value: "156.00k",
                  change: "+150 today",
                  percent: "20%",
                  isIncrease: false,
                ),
                StatCard(
                  title: "Non-Active Users",
                  value: "016.10k",
                  change: "+150 today",
                  percent: "10%",
                  isIncrease: true,
                ),
                StatCard(
                  title: "Total Users",
                  value: "400.00k",
                  change: "+150 today",
                  percent: "10%",
                  isIncrease: true,
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Line Chart
            const Expanded(
              child: Card(
                elevation: 3,
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Total Users",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 20),
                      Expanded(child: UserLineChart()),
                    ],
                  ),
                ),
              ),
            ),
          ],
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
              Text(title,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500)),
              const SizedBox(height: 10),
              Text(value,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold)),
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
                        color: isIncrease ? Colors.green : Colors.red),
                  ),
                  const SizedBox(width: 5),
                  Text(change, style: const TextStyle(color: Colors.grey)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class UserLineChart extends StatelessWidget {
  const UserLineChart({super.key});

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        lineBarsData: [
          LineChartBarData(
            isCurved: true,
            spots: const [
              FlSpot(0, 10),
              FlSpot(1, 12),
              FlSpot(2, 8),
              FlSpot(3, 15),
              FlSpot(4, 25),
              FlSpot(5, 20),
              FlSpot(6, 30),
            ],
            color: Colors.green,
            barWidth: 3,
          ),
          LineChartBarData(
            isCurved: true,
            spots: const [
              FlSpot(0, 8),
              FlSpot(1, 10),
              FlSpot(2, 12),
              FlSpot(3, 18),
              FlSpot(4, 15),
              FlSpot(5, 22),
              FlSpot(6, 28),
            ],
            color: Colors.grey,
            barWidth: 2,
            dashArray: [5, 5],
          ),
        ],
        titlesData: FlTitlesData(
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: true, reservedSize: 40),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul"];
                if (value.toInt() < months.length) {
                  return Text(months[value.toInt()]);
                }
                return const Text("");
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        gridData: const FlGridData(show: false),
      ),
    );
  }
}
