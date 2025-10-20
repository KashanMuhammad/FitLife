import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared/user_0nboarding_data_model_class.dart';

import 'dateofbirth_input_screen.dart';

class WeightInputScreen extends StatefulWidget {
  const WeightInputScreen({super.key});

  @override
  _WeightInputScreenState createState() => _WeightInputScreenState();
}

class _WeightInputScreenState extends State<WeightInputScreen> {
  bool isKgSelected = true;

  final List<int> kgList = List.generate(151, (index) => 30 + index);
  int selectedKgIndex = 30;

  final List<int> lbsList = List.generate(221, (index) => 66 + index);
  int selectedLbsIndex = 34;

  final FixedExtentScrollController kgController = FixedExtentScrollController(
    initialItem: 30,
  );
  final FixedExtentScrollController lbsController = FixedExtentScrollController(
    initialItem: 34,
  );

  final Color selectedBackgroundColor = const Color(0xFFE9FDE3);
  final Color selectedTextColor = Colors.green;

  int _lbsToKg(int lbs) => (lbs / 2.205).round();

  @override
  void dispose() {
    kgController.dispose();
    lbsController.dispose();
    super.dispose();
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
              minHeight:
                  screenHeight - screenPadding.top - screenPadding.bottom,
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
                            text: '4',
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const TextSpan(
                            text: ' / 7',
                            style: TextStyle(color: Colors.black, fontSize: 18),
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
                            text: 'What\'s Your ',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          TextSpan(
                            text: 'Weight?',
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
                  const Text(
                    "      Provide details about your health, dietary    ",
                  ),
                  const Text(
                    "habit and goals to receive a personalized diet",
                    style: TextStyle(fontStyle: FontStyle.normal),
                  ),
                  const Text(
                    "         recommendation from your doctor         ",
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _unitButton("kg", isKgSelected, () {
                        setState(() => isKgSelected = true);
                      }),
                      const SizedBox(width: 10),
                      _unitButton("lbs", !isKgSelected, () {
                        setState(() => isKgSelected = false);
                      }),
                    ],
                  ),
                  const SizedBox(height: 30),
                  isKgSelected ? _buildKgPicker() : _buildLbsPicker(),
                  SizedBox(height: 227),
                  buildNextButton(context),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Center buildNextButton(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: () async {
          int weightValue =
              isKgSelected
                  ? kgList[selectedKgIndex]
                  : lbsList[selectedLbsIndex];
          String weightUnit = isKgSelected ? 'kg' : 'lbs';

          await handleWeightInput(weightValue, weightUnit);

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const DateofbirthInputScreen(),
            ),
          );
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
    );
  }

  Future<void> handleWeightInput(int weightValue, String weightUnit) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userId = user.uid;
      try {
        final userModel = FirebaseDataModelClass(
          weight: weightValue.toDouble(),
          weightUnit: weightUnit,
        );
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(userId)
            .update(userModel.toJson());
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save weight'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  Widget _buildKgPicker() {
    return SizedBox(
      height: 150,
      child: ListWheelScrollView.useDelegate(
        controller: kgController,
        itemExtent: 40,
        diameterRatio: 1.2,
        perspective: 0.005,
        physics: const FixedExtentScrollPhysics(),
        onSelectedItemChanged: (index) {
          setState(() => selectedKgIndex = index);
        },
        childDelegate: ListWheelChildBuilderDelegate(
          builder: (context, index) {
            final isSelected = index == selectedKgIndex;
            return _scrollItem(
              value: isSelected ? "${kgList[index]} kg" : "${kgList[index]}",
              isSelected: isSelected,
            );
          },
          childCount: kgList.length,
        ),
      ),
    );
  }

  Widget _buildLbsPicker() {
    return SizedBox(
      height: 150,
      child: ListWheelScrollView.useDelegate(
        controller: lbsController,
        itemExtent: 40,
        diameterRatio: 1.2,
        perspective: 0.005,
        physics: const FixedExtentScrollPhysics(),
        onSelectedItemChanged: (index) {
          setState(() => selectedLbsIndex = index);
        },
        childDelegate: ListWheelChildBuilderDelegate(
          builder: (context, index) {
            final isSelected = index == selectedLbsIndex;
            return _scrollItem(
              value: isSelected ? "${lbsList[index]} lbs" : "${lbsList[index]}",
              isSelected: isSelected,
            );
          },
          childCount: lbsList.length,
        ),
      ),
    );
  }

  Widget _scrollItem({required String value, required bool isSelected}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration:
          isSelected
              ? BoxDecoration(
                color: selectedBackgroundColor,
                borderRadius: BorderRadius.circular(12),
              )
              : null,
      child: Center(
        child: Text(
          value,
          style: TextStyle(
            color: isSelected ? selectedTextColor : Colors.black,
            fontSize: isSelected ? 20 : 16,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _unitButton(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? selectedBackgroundColor : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? selectedTextColor : Colors.grey.shade300,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? selectedTextColor : Colors.black54,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
