import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';


import 'custom widgets/custom_inkwell.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
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
                obscureText: true,
              ),
              CustomTextFormField(
                hintText: "Confirm Password",
                controller: confirmPasswordController,
                suffixSvgAsset: "assets/images/lock.svg",
                obscureText: true,
              ),
              //const SizedBox(height: 20),
              CustomInkWellContainer(onTap: (){}, text: "Sign Up"),


              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: Colors.grey,
                        thickness: 1,
                      ),
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
                      child: Divider(
                        color: Colors.grey,
                        thickness: 1,
                      ),
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
                  Text("Already have an account?"),
                  InkWell(
                      onTap: (){},
                      child: Text("login",style: TextStyle(color: Colors.green),))
                ],
              ),


            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton(String assetPath) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: InkWell(
        onTap: () {
          // Handle social button tap
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white30,
          ),
          child: Center(
            child: SvgPicture.asset(assetPath),
          ),
        ),
      ),
    );
  }
}
