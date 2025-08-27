import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared/user_0nboarding_data_model_class.dart';
import 'height_input_screen.dart';

class GenderScreen extends StatefulWidget {
  const GenderScreen({super.key});

  @override
  State<GenderScreen> createState() => _GenderScreenState();
}

class _GenderScreenState extends State<GenderScreen> {
  String? selectedGender;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(15.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom,
            ),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),
                  const Text("2 / 7", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
                  const SizedBox(height: 10),
                  const Text("What's Your Gender?", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text("Provide details about your health, dietary"),
                  const Text("habit and goals to receive a personalized diet"),
                  const Text("recommendation from your doctor"),
                   SizedBox(
                    height: 180,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GenderOption(
                        assetName: 'assets/images/males.svg',
                        label: "Male",
                        isSelected: selectedGender == "Male",
                        onTap: () {
                          setState(() {
                            selectedGender = "Male";
                          });
                        },
                      ),
                      GenderOption(
                        assetName: 'assets/images/Female.svg',
                        label: "Female",
                        isSelected: selectedGender == "Female",
                        onTap: () {
                          setState(() {
                            selectedGender = "Female";
                          });
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 200,
                  ),
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

  Widget buildNextButton(BuildContext context) {
    return InkWell(
      onTap: isLoading || selectedGender == null
          ? null
          : () async {
        setState(() => isLoading = true);
        final userId = FirebaseAuth.instance.currentUser?.uid;
        if (userId == null) {
          showSnackbar('User not authenticated.');
          setState(() => isLoading = false);
          return;
        }

        try {
          final userModel= FirebaseDataModelClass(

            gender: selectedGender,
          );
          await FirebaseFirestore.instance
              .collection('Khan')
              .doc(userId)
              .set(userModel.toJson(), SetOptions(merge: true));

          Navigator.push(context, MaterialPageRoute(builder: (context) => const HeightInputScreen()));
        } catch (e) {
          showSnackbar('Failed to save gender.');
        } finally {
          setState(() => isLoading = false);
        }
      },
      child: Container(
        height: 50,
        width: 300,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: const LinearGradient(colors: [Color(0xFF5AFF15), Color(0xFF00B712)]),
        ),
        child: isLoading
            ? const Center(child: CircularProgressIndicator(color: Colors.white))
            : const Center(
          child: Text(
            "Next",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18),
          ),
        ),
      ),
    );
  }

  void showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.redAccent),
    );
  }
}

class GenderOption extends StatelessWidget {
  final String assetName;
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;

  const GenderOption({
    required this.assetName,
    required this.label,
    this.isSelected = false,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: isSelected ? Colors.green.withOpacity(0.3) : Colors.green.withOpacity(0.2),
            child: SvgPicture.asset(
              assetName,
              width: 30,
              height: 30,
              color: isSelected ? Colors.green[800] : null,
            ),
          ),
          const SizedBox(height: 8),
          Text(label),
          if (isSelected)
            Container(
              margin: const EdgeInsets.only(top: 4),
              height: 2,
              width: 40,
              color: Colors.green,
            ),
        ],
      ),
    );
  }
}
