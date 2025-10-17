import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitlife_app/custom widgets/option_card.dart';
import 'package:fitlife_app/delete_account_setting.dart';
import 'package:fitlife_app/edit_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared/user_0nboarding_data_model_class.dart';

class UserAndProfileScreen extends StatefulWidget {
  const UserAndProfileScreen({super.key});

  @override
  State<UserAndProfileScreen> createState() => _UserAndProfileScreenState();
}

class _UserAndProfileScreenState extends State<UserAndProfileScreen> {
  final String _label = "Healthy";
  FirebaseDataModelClass? userModel;
  bool _isUploading = false;
  String? _profileImageUrl;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser!.uid;
      final doc = await FirebaseFirestore.instance.collection('Users').doc(currentUser).get();

      if (doc.exists) {
        setState(() {
          userModel = FirebaseDataModelClass.fromJson(doc.data()!);
          _profileImageUrl = doc.data()?['profileImageUrl'];
        });
      }
    } catch (e) {
      debugPrint("⚠️ Error fetching user data: $e");
    }
  }

  /// ✅ Pick image and upload to Supabase 'profile_images' bucket
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

      // ✅ Get a public URL for the uploaded file
      final publicUrl = supabase.storage.from('profile_images').getPublicUrl(fileName);

      // ✅ Save image URL to Firestore user document
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .update({'profileImageUrl': publicUrl});

      // ✅ Update local UI
      setState(() {
        _profileImageUrl = publicUrl;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Profile image uploaded successfully!')),
      );
    } on StorageException catch (e) {
      debugPrint("⚠️ Supabase storage error: ${e.message}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Storage error: ${e.message}')),
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

  @override
  Widget build(BuildContext context) {
    final userName = userModel?.username ?? "Loading...";

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(19.0),
                    child: Text(
                      "User",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                  ),

                  // ✅ Profile Image Avatar + Upload Button
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey[300],
                        backgroundImage: _profileImageUrl != null
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

                  const SizedBox(height: 10),
                  Text(
                    userName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(_label),
                  const SizedBox(height: 35),

                  // 🔹 GridView for Options
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 15,
                    crossAxisSpacing: 15,
                    childAspectRatio: 1.2,
                    children: [
                      OptionCard(
                        title: "Subscription",
                        imageAssetPath: 'assets/images/Subscription.png',
                        onTap: () {},
                        backgroundColor: const Color(0xFFFFF9E5),
                      ),
                      OptionCard(
                        title: "Profile",
                        imageAssetPath: 'assets/images/Group.png',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const EditProfileScreen(),
                            ),
                          );
                        },
                        backgroundColor: const Color(0xFFEAFBEA),
                      ),
                      OptionCard(
                        title: "Settings",
                        imageAssetPath: 'assets/images/Setting.png',
                        onTap: () {},
                        backgroundColor: const Color(0xFFE9F0F9),
                      ),
                      OptionCard(
                        title: "Privacy Policy",
                        imageAssetPath: 'assets/images/PrivacyPolicy.png',
                        onTap: () {},
                        backgroundColor: const Color(0xFFE6FAFA),
                      ),
                      OptionCard(
                        title: "Help",
                        imageAssetPath: 'assets/images/Help.png',
                        onTap: () {},
                        backgroundColor: const Color(0xFFE4F0FF),
                      ),
                    ],
                  ),

                  const SizedBox(height: 35),

                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DeleteAccountSetting(),
                        ),
                      );
                    },
                    child: Container(
                      height: 45,
                      width: 250,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: const Color(0x88FF6B6B),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Log out  "),
                          SvgPicture.asset('assets/images/icon.svg'),
                        ],
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
}
