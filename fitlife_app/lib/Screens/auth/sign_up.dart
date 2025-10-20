import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared/user_0nboarding_data_model_class.dart';

import '../Onboarding Screens/SkipScreens.dart';
import '../custom widgets/custom_textformfield.dart';
import 'login_screen.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool isLoading = false;
  bool passwordVisible = false;
  bool confirmPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Welcome Back ",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SvgPicture.asset("assets/images/hand.svg"),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  "Your journey continued stay committed and focused",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 50),
                const Text(
                  "Sign Up",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 15),
                CustomTextFormField(
                  hintText: "Full Name",
                  controller: nameController,
                  suffixSvgAsset: "assets/images/person.svg",
                  keyboardType: TextInputType.name,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty)
                      return 'Name is required';
                    if (!RegExp(r"^[a-zA-Z\s]+$").hasMatch(value))
                      return 'Name can only contain letters';
                    return null;
                  },
                ),
                CustomTextFormField(
                  hintText: "Email",
                  controller: emailController,
                  suffixSvgAsset: "assets/images/mail.svg",
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty)
                      return 'Email is required';
                    if (!RegExp(
                      r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$",
                    ).hasMatch(value))
                      return 'Enter a valid email';
                    return null;
                  },
                ),
                CustomTextFormField(
                  hintText: "Password",
                  controller: passwordController,
                  suffixSvgAsset: "assets/images/lock.svg",
                  obscureText: !passwordVisible,
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Password is required';
                    if (!isValidPassword(value))
                      return 'Must be 6+ chars, include upper, lower, number, special char';
                    return null;
                  },
                ),
                CustomTextFormField(
                  hintText: "Confirm Password",
                  controller: confirmPasswordController,
                  suffixSvgAsset: "assets/images/lock.svg",
                  obscureText: !confirmPasswordVisible,
                  suffixIcon: IconButton(
                    icon: Icon(
                      confirmPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.grey,
                    ),
                    onPressed:
                        () => setState(
                          () =>
                              confirmPasswordVisible = !confirmPasswordVisible,
                        ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Confirm your password';
                    if (value != passwordController.text)
                      return 'Passwords do not match';
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                buildNextButton(context),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(color: Colors.grey, thickness: 1),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          "OR",
                          style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(color: Colors.grey, thickness: 1),
                      ),
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
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        "Login",
                        style: TextStyle(color: Colors.green),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Center buildNextButton(BuildContext context) {
    return Center(
      child: InkWell(
        onTap:
            isLoading
                ? null
                : () {
                  if (_formKey.currentState!.validate()) {
                    handleSignUp();
                  }
                },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 50,
          width: 400,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: const LinearGradient(
              colors: [Color(0xFF5AFF15), Color(0xFF00B712)],
            ),
          ),
          alignment: Alignment.center,
          child:
              isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                    "Sign up",
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

  Future<void> handleSignUp() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    setState(() => isLoading = true);

    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      final userId = credential.user?.uid ?? '';

      final userData = FirebaseDataModelClass(
        email: email,
        password: password,
        username: name,
      );

      try {
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(userId)
            .set(userData.toJson());
      } catch (e) {
        print('Firestore error: $e');
        showSnackbar(context, 'Failed to save data to Firestore.');
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SkipScreens()),
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
    return RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).{6,}$',
    ).hasMatch(password);
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
