import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitlife_app/Screens/Onboarding%20Screens/weight_input_screen.dart';

import 'package:flutter/material.dart';
import 'package:shared/user_0nboarding_data_model_class.dart';

class HeightInputScreen extends StatefulWidget {
  const HeightInputScreen({super.key});

  @override
  _HeightInputScreenState createState() => _HeightInputScreenState();
}

class _HeightInputScreenState extends State<HeightInputScreen> {
  bool isCmSelected = true;

  final List<int> cmList = List.generate(121, (index) => 100 + index);
  int selectedCmIndex = 70;

  final List<int> feetList = List.generate(4, (index) => 4 + index);
  final List<int> inchList = List.generate(12, (index) => index);
  int selectedFtIndex = 1;
  int selectedInIndex = 8;

  final Color selectedBackgroundColor = const Color(0xFFE9FDE3);
  final Color selectedTextColor = Colors.green;

  final FixedExtentScrollController cmController = FixedExtentScrollController(
    initialItem: 70,
  );
  final FixedExtentScrollController ftController = FixedExtentScrollController(
    initialItem: 1,
  );
  final FixedExtentScrollController inchController =
      FixedExtentScrollController(initialItem: 8);

  int _feetInchToCm(int ft, int inch) => (((ft * 12) + inch) * 2.54).round();

  @override
  void dispose() {
    cmController.dispose();
    ftController.dispose();
    inchController.dispose();
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
                            text: '3',
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
                            text: 'Height?',
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
                      _unitButton("cm", isCmSelected, () {
                        setState(() => isCmSelected = true);
                      }),
                      const SizedBox(width: 10),
                      _unitButton("ft", !isCmSelected, () {
                        setState(() => isCmSelected = false);
                      }),
                    ],
                  ),
                  const SizedBox(height: 30),
                  isCmSelected ? _buildCmPicker() : _buildFeetInchPicker(),
                  const SizedBox(height: 225),
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
          final success = await handleHeightInput();
          if (success) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const WeightInputScreen(),
              ),
            );
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
    );
  }

  Future<dynamic> handleHeightInput() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userId = user.uid;

      double? heightValue;
      String heightUnit;

      if (isCmSelected) {
        if (selectedCmIndex < 0 || selectedCmIndex >= cmList.length) {
          return Text("Invalid height selection.");
        }
        heightValue = cmList[selectedCmIndex].toDouble();
        heightUnit = 'cm';
      } else {
        if (selectedFtIndex < 0 ||
            selectedFtIndex >= feetList.length ||
            selectedInIndex < 0 ||
            selectedInIndex >= inchList.length) {
          return Text("Invalid height selection.");
        }

        double ft = feetList[selectedFtIndex].toDouble();
        double inch = inchList[selectedInIndex].toDouble();

        // ✅ Fixed precise conversion: store accurate ft.in (e.g. 5.5 = 5 ft 6 in)
        heightValue = double.parse((ft + (inch / 12)).toStringAsFixed(2));
        heightUnit = 'ft_in';
      }

      try {
        final userModel = FirebaseDataModelClass(
          height: heightValue,
          heightUnit: heightUnit,
        );

        await FirebaseFirestore.instance
            .collection('Users')
            .doc(userId)
            .update(userModel.toJson());

        return true;
      } catch (e) {
        return Text("Failed to save height.");
      }
    }
    return Text("User not logged in.");
  }

  Widget _buildCmPicker() {
    return SizedBox(
      height: 150,
      child: ListWheelScrollView.useDelegate(
        controller: cmController,
        itemExtent: 40,
        diameterRatio: 1.2,
        perspective: 0.005,
        physics: const FixedExtentScrollPhysics(),
        onSelectedItemChanged: (index) {
          setState(() => selectedCmIndex = index);
        },
        childDelegate: ListWheelChildBuilderDelegate(
          builder: (context, index) {
            final isSelected = index == selectedCmIndex;
            return _scrollItem(
              value: isSelected ? "${cmList[index]} cm" : "${cmList[index]}",
              isSelected: isSelected,
            );
          },
          childCount: cmList.length,
        ),
      ),
    );
  }

  Widget _buildFeetInchPicker() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 150,
          width: 80,
          child: ListWheelScrollView.useDelegate(
            controller: ftController,
            itemExtent: 40,
            diameterRatio: 1.2,
            perspective: 0.005,
            physics: const FixedExtentScrollPhysics(),
            onSelectedItemChanged: (index) {
              setState(() => selectedFtIndex = index);
            },
            childDelegate: ListWheelChildBuilderDelegate(
              builder: (context, index) {
                final isSelected = index == selectedFtIndex;
                return _scrollItem(
                  value:
                      isSelected
                          ? "${feetList[index]} ft"
                          : "${feetList[index]}",
                  isSelected: isSelected,
                );
              },
              childCount: feetList.length,
            ),
          ),
        ),
        const SizedBox(width: 10),
        SizedBox(
          height: 150,
          width: 80,
          child: ListWheelScrollView.useDelegate(
            controller: inchController,
            itemExtent: 40,
            diameterRatio: 1.2,
            perspective: 0.005,
            physics: const FixedExtentScrollPhysics(),
            onSelectedItemChanged: (index) {
              setState(() => selectedInIndex = index);
            },
            childDelegate: ListWheelChildBuilderDelegate(
              builder: (context, index) {
                final isSelected = index == selectedInIndex;
                return _scrollItem(
                  value:
                      isSelected
                          ? "${inchList[index]} inch"
                          : "${inchList[index]}",
                  isSelected: isSelected,
                );
              },
              childCount: inchList.length,
            ),
          ),
        ),
      ],
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
