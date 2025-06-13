import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'diet_habits_input_screen.dart';

class DateofbirthInputScreen extends StatefulWidget {
  const DateofbirthInputScreen({super.key});

  @override
  State<DateofbirthInputScreen> createState() => _DateofbirthInputScreenState();
}

class _DateofbirthInputScreenState extends State<DateofbirthInputScreen> {
  final Color selectedBackgroundColor = const Color(0xFFE9FDE3);
  final Color selectedTextColor = Colors.green;

  final List<int> years = List.generate(100, (index) => DateTime.now().year - index);
  final List<int> months = List.generate(12, (index) => index + 1);
  final List<int> days = List.generate(31, (index) => index + 1);

  late final int randomDayIndex;
  late final int randomMonthIndex;
  late final int randomYearIndex;

  late int selectedDayIndex;
  late int selectedMonthIndex;
  late int selectedYearIndex;

  late FixedExtentScrollController dayController;
  late FixedExtentScrollController monthController;
  late FixedExtentScrollController yearController;

  @override
  void initState() {
    super.initState();
    randomDayIndex = Random().nextInt(31);
    randomMonthIndex = Random().nextInt(12);
    randomYearIndex = Random().nextInt(100);

    selectedDayIndex = randomDayIndex;
    selectedMonthIndex = randomMonthIndex;
    selectedYearIndex = randomYearIndex;

    dayController = FixedExtentScrollController(initialItem: randomDayIndex);
    monthController = FixedExtentScrollController(initialItem: randomMonthIndex);
    yearController = FixedExtentScrollController(initialItem: randomYearIndex);
  }

  @override
  void dispose() {
    dayController.dispose();
    monthController.dispose();
    yearController.dispose();
    super.dispose();
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenPadding = MediaQuery.of(context).padding;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(15.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: screenHeight - screenPadding.top - screenPadding.bottom,
            ),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  const SizedBox(height: 50),
                  Center(
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '5',
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const TextSpan(
                            text: ' / 7',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Whats Your ',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          TextSpan(
                            text: 'Birth Day?',
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.normal,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text("     Choose your special calendar day below     "),
                  const Text(
                    "so we can tailor the plan that suits your needs",
                    style: TextStyle(fontStyle: FontStyle.normal),
                  ),
                  const Text("             and long-term health goals              "),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildWheel(
                        values: days.map((d) => d.toString()).toList(),
                        controller: dayController,
                        selectedIndex: selectedDayIndex,
                        onSelectedItemChanged: (index) {
                          setState(() => selectedDayIndex = index);
                        },
                      ),
                      const SizedBox(width: 10),
                      _buildWheel(
                        values: months.map((m) => DateFormat.MMM().format(DateTime(0, m))).toList(),
                        controller: monthController,
                        selectedIndex: selectedMonthIndex,
                        onSelectedItemChanged: (index) {
                          setState(() => selectedMonthIndex = index);
                        },
                      ),
                      const SizedBox(width: 10),
                      _buildWheel(
                        values: years.map((y) => y.toString()).toList(),
                        controller: yearController,
                        selectedIndex: selectedYearIndex,
                        onSelectedItemChanged: (index) {
                          setState(() => selectedYearIndex = index);
                        },
                      ),
                    ],
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () async {
                      final user = FirebaseAuth.instance.currentUser;
                      if (user != null) {
                        try {
                          int selectedDay = days[selectedDayIndex];
                          int selectedMonth = months[selectedMonthIndex];
                          int selectedYear = years[selectedYearIndex];

                          final dob = DateTime(selectedYear, selectedMonth, selectedDay);
                          final now = DateTime.now();

                          if (dob.isAfter(now)) {
                            _showError('Date of birth cannot be in the future.');
                            return;
                          }

                          final age = now.year - dob.year - ((now.month < dob.month || (now.month == dob.month && now.day < dob.day)) ? 1 : 0);
                          if (age < 13) {
                            _showError('You must be at least 13 years old.');
                            return;
                          }

                          await FirebaseFirestore.instance
                              .collection('Users')
                              .doc(user.uid)
                              .update({'dateOfBirth': dob.toIso8601String()});

                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => DietHabitsInputScreen()),
                          );
                        } catch (e) {
                          _showError('Invalid date selected.');
                        }
                      }
                    },
                    child: Container(
                      height: 50,
                      width: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: const LinearGradient(
                          colors: [Color(0xFF5AFF15), Color(0xFF00B712)],
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          "Next",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWheel({
    required List<String> values,
    required FixedExtentScrollController controller,
    required int selectedIndex,
    required ValueChanged<int> onSelectedItemChanged,
  }) {
    return SizedBox(
      height: 150,
      width: 80,
      child: ListWheelScrollView.useDelegate(
        controller: controller,
        itemExtent: 40,
        diameterRatio: 1.2,
        perspective: 0.005,
        physics: const FixedExtentScrollPhysics(),
        onSelectedItemChanged: onSelectedItemChanged,
        childDelegate: ListWheelChildBuilderDelegate(
          builder: (context, index) {
            final isSelected = index == selectedIndex;
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: isSelected
                  ? BoxDecoration(
                color: selectedBackgroundColor,
                borderRadius: BorderRadius.circular(12),
              )
                  : null,
              child: Center(
                child: Text(
                  values[index],
                  style: TextStyle(
                    color: isSelected ? selectedTextColor : Colors.black,
                    fontSize: isSelected ? 20 : 16,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            );
          },
          childCount: values.length,
        ),
      ),
    );
  }
}
