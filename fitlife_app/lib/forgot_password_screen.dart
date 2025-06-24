import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitlife_app/custom%20widgets/custom_inkwell.dart';
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
          padding: EdgeInsets.all(25),
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
                SizedBox(height: 75),
                Center(
                  child: Text(
                    'Forgot Password',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                Text("Check your inbox for the passcode. It's needed to keep"),
                Center(child: Text("your account secure")),
                SizedBox(height: 25),
                CustomTextFormField(
                  hintText: "Email",
                  controller: emailController,
                  suffixSvgAsset: "assets/images/person.svg",
                ),
                SizedBox(height: 15,),
                CustomInkwell(text:"Reset Password" , onTap: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      await FirebaseAuth.instance
                          .sendPasswordResetEmail(email: emailController.text.trim());

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Password reset email sent!')),
                      );

                      Navigator.pop(context); // Optional: go back after success
                    } on FirebaseAuthException catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(e.message ?? 'Something went wrong')),
                      );
                    }
                  }
                },),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
