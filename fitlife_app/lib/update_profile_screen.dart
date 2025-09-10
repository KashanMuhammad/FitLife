import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared/user_0nboarding_data_model_class.dart';

import 'custom widgets/build_textformfield.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  FirebaseDataModelClass? userModel;

  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController dateofbirthController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController currentWeightController = TextEditingController();
  TextEditingController goalWeightController = TextEditingController();
  TextEditingController heightController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  static const String uid = "3UCi7hE0jHNl79r7dIzA3wl0D083";

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  /// 🔹 Fetch user data and fill controllers
  Future<void> fetchUserData() async {
    final doc =
    await FirebaseFirestore.instance.collection('Users').doc(uid).get();

    if (doc.exists) {
      userModel = FirebaseDataModelClass.fromJson(doc.data()!);

      setState(() {
        usernameController.text = userModel?.username ?? '';
        emailController.text = userModel?.email ?? '';
        genderController.text = userModel?.gender ?? '';
        dateofbirthController.text = userModel?.dateOfBirth != null
            ? userModel!.dateOfBirth!.toIso8601String().split("T")[0]
            : '';

        /// ✅ Show current weight with unit
        if (userModel?.weight != null) {
          currentWeightController.text = userModel!.weightUnit != null
              ? "${userModel!.weight} ${userModel!.weightUnit}"
              : "${userModel!.weight}";
        }



        /// ✅ Show height with unit
        if (userModel?.height != null) {
          heightController.text = userModel!.heightUnit != null
              ? "${userModel!.height} ${userModel!.heightUnit}"
              : "${userModel!.height}";
        }
      });
    }
  }

  /// 🔹 Update user data (all fields)
  Future<void> updateUserData() async {
    if (!_formKey.currentState!.validate()) return;

    /// Split safely: [value, unit?]
    List<String> heightParts = heightController.text.trim().split(" ");
    List<String> weightParts = currentWeightController.text.trim().split(" ");

    final updatedUser = FirebaseDataModelClass(
      username: usernameController.text.trim().isNotEmpty
          ? usernameController.text.trim()
          : null,
      email: emailController.text.trim().isNotEmpty
          ? emailController.text.trim()
          : null,
      gender: genderController.text.trim().isNotEmpty
          ? genderController.text.trim()
          : null,
      dateOfBirth: dateofbirthController.text.trim().isNotEmpty
          ? DateTime.tryParse(dateofbirthController.text.trim())
          : null,

      /// ✅ Current Weight
      weight: weightParts.isNotEmpty ? double.tryParse(weightParts.first) : null,
      weightUnit: weightParts.length > 1
          ? weightParts.last
          : userModel?.weightUnit, // keep old unit if missing



      /// ✅ Height
      height: heightParts.isNotEmpty ? double.tryParse(heightParts.first) : null,
      heightUnit: heightParts.length > 1
          ? heightParts.last
          : userModel?.heightUnit, // keep old unit if missing
    );

    final fullData = updatedUser.toJson();

    // 🔹 remove nulls
    final dataToUpdate = <String, dynamic>{};
    fullData.forEach((key, value) {
      if (value != null && value.toString().trim().isNotEmpty) {
        dataToUpdate[key] = value;
      }
    });

    if (dataToUpdate.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(uid)
          .update(dataToUpdate);

      /// ✅ Refresh controllers with latest updated values
      await fetchUserData();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No changes to update')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_ios),
                    ),
                    const SizedBox(width: 77),
                    const Padding(
                      padding: EdgeInsets.all(25.0),
                      child: Center(
                        child: Text(
                          "Profile",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 11),
                Center(
                  child: CircleAvatar(
                    radius: 50,
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/Male.png',
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text("     Full Name",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black)),
                BuildTextformfield(
                  controller: usernameController,
                  svgIconPath: 'assets/images/person.svg',
                  readOnly: false,
                  validator: usernameValidator,
                ),
                Text("     Email",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black)),
                BuildTextformfield(
                  controller: emailController,
                  svgIconPath: 'assets/images/mail.svg',
                  readOnly: false,
                  validator: emailValidator,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("      Date of Birth",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                            BuildTextformfield(
                              controller: dateofbirthController,
                              svgIconPath: 'assets/images/Calender.svg',
                              readOnly: false,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("     Gender",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                            BuildTextformfield(
                              controller: genderController,
                              svgIconPath: 'assets/images/Gender.svg',
                              readOnly: false,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("      Current Weight",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                            BuildTextformfield(
                              controller: currentWeightController,
                              svgIconPath: 'assets/images/Weight.svg',
                              readOnly: false,
                              validator: numberValidator,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("     Goal Weight",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                            BuildTextformfield(
                              controller: goalWeightController,
                              svgIconPath: 'assets/images/Weight.svg',
                              readOnly: false,
                              validator: numberValidator,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Text("       Height",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black)),
                BuildTextformfield(
                  controller: heightController,
                  svgIconPath: 'assets/images/Height.svg',
                  readOnly: false,
                  validator: numberValidator,
                ),
                const SizedBox(height: 20),
                Center(child: buildUpdateButton(context)),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildUpdateButton(BuildContext context) {
    return InkWell(
      onTap: updateUserData,
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
            "Update Profile",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }
}
