import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitlife_app/custom%20widgets/custom_textformfield.dart';
import 'package:fitlife_app/home_screen.dart';
import 'package:fitlife_app/main_screen.dart';
import 'package:fitlife_app/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared/user_0nboarding_data_model_class.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;
  bool passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 40),
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
                  "Log In",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 15),
                CustomTextFormField(
                  hintText: 'Email',
                  controller: emailController,
                  suffixSvgAsset: "assets/images/mail.svg",
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) return "Email Address require";
                    if (!RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(value)) return 'Enter a valid email';
                    return null;
                  },
                ),
                CustomTextFormField(
                  hintText: "Password",
                  controller: passwordController,
                  suffixSvgAsset: "assets/images/lock.svg",
                  obscureText: !passwordVisible,
                  validator: (value) {
                    if (value == null || value.isEmpty) return "Password is required";
                    if (!isValidPassword(value)) return 'Must be 6+ chars, include upper, lower, number, special char';
                    return null;
                  },
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
                    const Text("Don't have an account ?"),
                    InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => SignUp()));
                      },
                      child: const Text("Sign Up", style: TextStyle(color: Colors.green)),
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
        onTap: isLoading
            ? null
            : () {
          if (_formKey.currentState!.validate()) {
            handleLogin();
          }
        },
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
              : const Text("Login", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18)),
        ),
      ),
    );
  }

  Future<void> handleLogin() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    setState(() => isLoading = true);

    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final userId = credential.user?.uid ?? '';

      final doc = await FirebaseFirestore.instance.collection('Khan').doc(userId).get();

      if (doc.exists) {
        final userData = FirebaseDataModelClass.fromJson(doc.data()!);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainScreen()),
        );
      } else {
        showSnackbar(context, 'User data not found in Firestore.');
        setState(() => isLoading = false);
        return;
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'invalid-email':
          errorMessage = 'Invalid email address.';
          break;
        case 'user-not-found':
          errorMessage = 'No user found for this email.';
          break;
        case 'wrong-password':
          errorMessage = 'Incorrect password.';
          break;
        default:
          errorMessage = 'Login failed: ${e.message}';
      }
      showSnackbar(context, errorMessage);
    } catch (e) {
      print('Login error: $e');
      showSnackbar(context, 'An unexpected error occurred.');
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
