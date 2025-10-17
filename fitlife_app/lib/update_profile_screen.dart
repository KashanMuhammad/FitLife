import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
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
  bool _isUploading = false;
  String? _profileImageUrl;

  static String uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  /// 🔹 Fetch user data
  Future<void> fetchUserData() async {
    final doc = await FirebaseFirestore.instance.collection('Users').doc(uid).get();

    if (doc.exists) {
      userModel = FirebaseDataModelClass.fromJson(doc.data()!);
      setState(() {
        usernameController.text = userModel?.username ?? '';
        emailController.text = userModel?.email ?? '';
        genderController.text = userModel?.gender ?? '';
        _profileImageUrl = userModel?.profileImageUrl;

        dateofbirthController.text = userModel?.dateOfBirth != null
            ? userModel!.dateOfBirth!.toIso8601String().split("T")[0]
            : '';

        if (userModel?.weight != null) {
          currentWeightController.text = userModel!.weightUnit != null
              ? "${userModel!.weight} ${userModel!.weightUnit}"
              : "${userModel!.weight}";
        }

        if (userModel?.height != null) {
          heightController.text = userModel!.heightUnit != null
              ? "${userModel!.height} ${userModel!.heightUnit}"
              : "${userModel!.height}";
        }
      });
    }
  }

  /// 🔹 Upload new profile image to Supabase
  Future<void> _pickAndUploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;

    setState(() => _isUploading = true);

    try {
      final user = FirebaseAuth.instance.currentUser!;
      final supabase = Supabase.instance.client;
      final file = File(pickedFile.path);
      final fileName = 'profile_${user.uid}_${DateTime.now().millisecondsSinceEpoch}.jpg';

      // ✅ Upload image to Supabase Storage bucket 'profile_images'
      await supabase.storage.from('profile_images').upload(fileName, file);

      // ✅ Get public URL
      final publicUrl = supabase.storage.from('profile_images').getPublicUrl(fileName);

      // ✅ Update Firestore
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .update({'profileImageUrl': publicUrl});

      setState(() {
        _profileImageUrl = publicUrl;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Profile image updated successfully!')),
      );
    } catch (e) {
      debugPrint("⚠️ Upload failed: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Upload failed: $e')),
      );
    } finally {
      setState(() => _isUploading = false);
    }
  }

  /// 🔹 Update text fields
  Future<void> updateUserData() async {
    if (!_formKey.currentState!.validate()) return;

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
      weight: weightParts.isNotEmpty ? double.tryParse(weightParts.first) : null,
      weightUnit: weightParts.length > 1
          ? weightParts.last
          : userModel?.weightUnit,
      height: heightParts.isNotEmpty ? double.tryParse(heightParts.first) : null,
      heightUnit: heightParts.length > 1
          ? heightParts.last
          : userModel?.heightUnit,
    );

    final fullData = updatedUser.toJson();
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

      await fetchUserData();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Profile updated successfully!')),
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

                // ✅ Avatar with edit icon
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey[300],
                        backgroundImage: _profileImageUrl != null &&
                            _profileImageUrl!.isNotEmpty
                            ? NetworkImage(_profileImageUrl!)
                            : const AssetImage('assets/images/Male.png')
                        as ImageProvider,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 4,
                        child: InkWell(
                          onTap: _isUploading ? null : _pickAndUploadImage,
                          child: CircleAvatar(
                            radius: 16,
                            backgroundColor: Colors.green,
                            child: _isUploading
                                ? const Padding(
                              padding: EdgeInsets.all(6.0),
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                                : const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
                const Text("     Full Name",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black)),
                BuildTextformfield(
                  controller: usernameController,
                  svgIconPath: 'assets/images/person.svg',
                  readOnly: false,
                  validator: usernameValidator,
                ),
                const Text("     Email",
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
                            const Text("      Date of Birth",
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
                            const Text("     Gender",
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
                            const Text("      Current Weight",
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
                            const Text("     Goal Weight",
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
                const Text("       Height",
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
