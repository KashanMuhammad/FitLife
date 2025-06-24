import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitlife_app/create_new_password_screen.dart';
import 'package:fitlife_app/custom%20widgets/custom_textformfield.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(25),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Color(0xFF363538),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 75),
                const Center(
                  child: Text(
                    'Forgot Password',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                const Text("Check your inbox for the passcode. It's needed to keep"),
                const Center(child: Text("your account secure")),
                const SizedBox(height: 25),
                CustomTextFormField(
                  hintText: "Email",
                  controller: emailController,
                  suffixSvgAsset: "assets/images/person.svg",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    } else if (!value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                InkWell(
                  onTap: () async {
                    if (_formKey.currentState!.validate()) {
                      try {
                        await FirebaseAuth.instance.sendPasswordResetEmail(
                          email: emailController.text.trim(),
                        );

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Password reset email sent!')),
                        );

                        Navigator.pop(context);
                      } on FirebaseAuthException catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(e.message ?? 'Something went wrong')),
                        );
                      }
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> CreateNewPasswordScreen()));
                    }
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    height: 50,
                    width: 250,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF5AFF15), Color(0xFF00B712)],
                      ),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      "Reset Password",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
