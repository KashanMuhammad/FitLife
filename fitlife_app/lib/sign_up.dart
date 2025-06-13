import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared/user_0nboarding_data_model_class.dart';
import 'Onboarding Screens/user_name_screen.dart';
import 'custom widgets/custom_textformfield.dart';


class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool isLoading = false;
  bool passwordVisible = false;
  bool confirmPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Welcome Back ", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
                  SvgPicture.asset("assets/images/hand.svg"),
                ],
              ),
              const SizedBox(height: 8),
              const Text("Your journey continued stay committed and focused", textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: Colors.black, fontStyle: FontStyle.italic)),
              const SizedBox(height: 50),
              const Text("Sign Up", textAlign: TextAlign.center, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black)),
              const SizedBox(height: 15),
              CustomTextFormField(
                hintText: "Full Name",
                controller: nameController,
                suffixSvgAsset: "assets/images/person.svg",
                keyboardType: TextInputType.name,
              ),
              CustomTextFormField(
                hintText: "Email",
                controller: emailController,
                suffixSvgAsset: "assets/images/mail.svg",
                keyboardType: TextInputType.emailAddress,
              ),
              CustomTextFormField(
                hintText: "Password",
                controller: passwordController,
                suffixSvgAsset: "assets/images/lock.svg",
                obscureText: !passwordVisible,
                suffixIcon: IconButton(
                  icon: Icon(passwordVisible ? Icons.visibility : Icons.visibility_off, color: Colors.grey),
                  onPressed: () => setState(() => passwordVisible = !passwordVisible),
                ),
              ),
              CustomTextFormField(
                hintText: "Confirm Password",
                controller: confirmPasswordController,
                suffixSvgAsset: "assets/images/lock.svg",
                obscureText: !confirmPasswordVisible,
                suffixIcon: IconButton(
                  icon: Icon(confirmPasswordVisible ? Icons.visibility : Icons.visibility_off, color: Colors.grey),
                  onPressed: () => setState(() => confirmPasswordVisible = !confirmPasswordVisible),
                ),
              ),
              const SizedBox(height: 30),
              buildNextButton(context),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  children: [
                    Expanded(child: Divider(color: Colors.grey, thickness: 1)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text("OR", style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold)),
                    ),
                    Expanded(child: Divider(color: Colors.grey, thickness: 1)),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildSocialButton("assets/images/Google.svg"),
                  _buildSocialButton("assets/images/Facebook.svg"),
                  _buildSocialButton("assets/images/Apple.svg"),
                ],
              ),
              const SizedBox(height: 30),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account?"),
                  InkWell(onTap: () {}, child: const Text("Login", style: TextStyle(color: Colors.green))),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Center buildNextButton(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: isLoading ? null : handleSignUp,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 50,
          width: 400,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: const LinearGradient(colors: [Color(0xFF5AFF15), Color(0xFF00B712)]),
          ),
          alignment: Alignment.center,
          child: isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text("Next", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18)),
        ),
      ),
    );
  }

  Future<void> handleSignUp() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      showSnackbar(context, 'All fields are required');
      return;
    }

    if (!RegExp(r"^[a-zA-Z\s]+$").hasMatch(name)) {
      showSnackbar(context, 'Name can only contain letters');
      return;
    }

    if (!RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(email)) {
      showSnackbar(context, 'Enter a valid email');
      return;
    }

    if (password != confirmPassword) {
      showSnackbar(context, 'Passwords do not match');
      return;
    }

    if (!isValidPassword(password)) {
      showSnackbar(context, 'Password must be 6+ characters, include upper/lowercase, number, and special character');
      return;
    }

    setState(() => isLoading = true);

    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final userId = credential.user?.uid ?? '';

      final userData = FirebaseDataModelClass(
        userId: userId,
        email: email,
        password: password,
        username: name,

      );
try {
  await FirebaseFirestore.instance.collection('Users').doc(userId).set(
      userData.toJson());
}
catch (e) {
  print('Firestore error: $e');
  showSnackbar(context, 'Failed to save data to Firestore.');
}      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const UserNameScreen()),
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = 'This email is already in use.';
          break;
        case 'invalid-email':
          errorMessage = 'Invalid email address.';
          break;
        case 'weak-password':
          errorMessage = 'Password is too weak.';
          break;
        default:
          errorMessage = 'Signup failed: ${e.message}';
      }
      showSnackbar(context, errorMessage);
    } finally {
      setState(() => isLoading = false);
    }
  }

  bool isValidPassword(String password) {
    return RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).{6,}$').hasMatch(password);
  }

  Widget _buildSocialButton(String assetPath) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white30,
          ),
          child: Center(child: SvgPicture.asset(assetPath)),
        ),
      ),
    );
  }

  void showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.redAccent),
    );
  }
}
