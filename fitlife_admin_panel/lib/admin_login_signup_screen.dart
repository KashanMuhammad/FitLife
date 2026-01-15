import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminLoginSignupScreen extends StatefulWidget {
  const AdminLoginSignupScreen({super.key});

  @override
  State<AdminLoginSignupScreen> createState() => _AdminLoginSignupScreenState();
}

class _AdminLoginSignupScreenState extends State<AdminLoginSignupScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final confirmCtrl = TextEditingController();

  bool isSignup = false;
  bool isLoading = false;

  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;

  // ---------------- VALIDATORS ----------------

  String? _emailValidator(String? value) {
    if (value == null || value.trim().isEmpty) return "Email is required";
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!regex.hasMatch(value.trim())) return "Enter a valid email";
    return null;
  }

  String? _passwordValidator(String? value) {
    if (value == null || value.isEmpty) return "Password is required";
    final regex = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&#]).{8,}$',
    );
    if (!regex.hasMatch(value))
      return "Min 8 chars, upper, lower, number & symbol";
    return null;
  }

  String? _confirmPasswordValidator(String? value) {
    if (value != passCtrl.text) return "Passwords do not match";
    return null;
  }

  // ---------------- SUBMIT ----------------

  Future<void> submit() async {
    if (!_formKey.currentState!.validate()) return; // FIELD VALIDATION

    setState(() => isLoading = true);

    try {
      if (isSignup) {
        final cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailCtrl.text.trim(),
          password: passCtrl.text.trim(),
        );

        await FirebaseFirestore.instance
            .collection('admins')
            .doc(cred.user!.uid)
            .set({
              'name': nameCtrl.text.trim(),
              'email': emailCtrl.text.trim(),
              'isActive': true,
            });
      } else {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailCtrl.text.trim(),
          password: passCtrl.text.trim(),
        );
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? "Something went wrong")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  void toggleForm() {
    setState(() {
      isSignup = !isSignup;

      // Clear password fields when switching forms
      emailCtrl.clear();
      passCtrl.clear();
      confirmCtrl.clear();

      // Optionally, you can also hide the password visibility
      _passwordVisible = false;
      _confirmPasswordVisible = false;

      _formKey.currentState?.reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF4BF314), Color(0xFF0BC012)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: width > 800 ? _buildWideLayout() : _buildNarrowLayout(),
        ),
      ),
    );
  }

  // ---------------- WIDE LAYOUT ----------------

  Widget _buildWideLayout() {
    return SizedBox(
      width: 900,
      height: 600,
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Fit",
                            style: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: Colors.orange,
                              shape: BoxShape.circle,
                            ),
                            child: const Text(
                              "Life",
                              style: TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Welcome to Admin Portal",
                        style: TextStyle(
                          fontSize: 28,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Manage your application easily and securely.",
                        style: TextStyle(fontSize: 16, color: Colors.black),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ---- FORM CARD ----
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              transitionBuilder: (child, animation) {
                final slide = Tween<Offset>(
                  begin: const Offset(1, 0),
                  end: Offset.zero,
                ).animate(animation);
                return SlideTransition(position: slide, child: child);
              },
              child: Container(
                key: ValueKey(isSignup),
                child: _buildFormCard(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- MOBILE ----------------

  Widget _buildNarrowLayout() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: _buildFormCard(),
      ),
    );
  }

  // ---------------- FORM CARD ----------------

  Widget _buildFormCard() {
    return Card(
      elevation: 12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Form(
          key: _formKey, // FORM KEY ADDED
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isSignup ? "Admin Sign Up" : "Admin Sign In",
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),

              if (isSignup)
                TextFormField(
                  controller: nameCtrl,
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? "Name is required"
                              : null,
                  decoration: InputDecoration(
                    labelText: "Admin Name",
                    prefixIcon: const Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              if (isSignup) const SizedBox(height: 16),

              TextFormField(
                controller: emailCtrl,
                validator: _emailValidator,
                decoration: InputDecoration(
                  labelText: "Email",
                  prefixIcon: const Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: passCtrl,
                obscureText: !_passwordVisible,
                validator: _passwordValidator,
                decoration: InputDecoration(
                  labelText: "Password",
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() => _passwordVisible = !_passwordVisible);
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              if (isSignup) const SizedBox(height: 16),

              if (isSignup)
                TextFormField(
                  controller: confirmCtrl,
                  obscureText: !_confirmPasswordVisible,
                  validator: _confirmPasswordValidator,
                  decoration: InputDecoration(
                    labelText: "Confirm Password",
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _confirmPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(
                          () =>
                              _confirmPasswordVisible =
                                  !_confirmPasswordVisible,
                        );
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF4BF314), Color(0xFF0BC012)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                    ),
                    onPressed: isLoading ? null : submit,
                    child:
                        isLoading
                            ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                            : Text(
                              isSignup ? "Create Admin" : "Sign In",
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              TextButton(
                onPressed: toggleForm,
                child: Text(
                  isSignup ? "Already an admin? Sign In" : "New admin? Sign Up",
                  style: const TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
