import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared/user_0nboarding_data_model_class.dart';
import 'gender_screen.dart';

class UserNameScreen extends StatefulWidget {
  const UserNameScreen({super.key});

  @override
  State<UserNameScreen> createState() => _UserNameScreenState();
}

class _UserNameScreenState extends State<UserNameScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController userNameController = TextEditingController();
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
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 50),
                    const Text("1 / 7", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
                    const SizedBox(height: 10),
                    const Text("What's Your Name?", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    const Text("Provide details about your health, dietary"),
                    const Text("habit and goals to receive a personalized diet"),
                    const Text("recommendation from your doctor"),
                    SizedBox(
                      height: 220,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 60),
                      child: buildTextFormField(),
                    ),
                    SizedBox(
                      height: 210,
                    ),
                    buildNextButton(context),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  TextFormField buildTextFormField() {
    return TextFormField(
      controller: userNameController,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'User Name is required';
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: "User Name",
        suffixIcon: const Icon(Icons.person_outline, color: Colors.green),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(width: 1, color: Colors.green),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(width: 2, color: Colors.green),
        ),
      ),
    );
  }

  Center buildNextButton(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: isLoading
            ? null
            : () async {
          if (_formKey.currentState!.validate()) {
            await handleUserNameSave();
          }
        },
        borderRadius: BorderRadius.circular(12),
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
      ),
    );
  }

  Future<void> handleUserNameSave() async {
    final username = userNameController.text.trim();
    setState(() => isLoading = true);

    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      showSnackbar('User not authenticated.');
      setState(() => isLoading = false);
      return;
    }

    try {
      final userModel = FirebaseDataModelClass(

        username: username,
      );
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .set(userModel.toJson(), SetOptions(merge: true));

      Navigator.push(context, MaterialPageRoute(builder: (context) => const GenderScreen()));
    } catch (e) {
      showSnackbar('Failed to save data to Firestore.');
    } finally {
      setState(() => isLoading = false);
    }
  }

  void showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.redAccent),
    );
  }
}
