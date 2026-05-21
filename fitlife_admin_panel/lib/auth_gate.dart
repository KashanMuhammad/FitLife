import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'admin_login_signup_screen.dart';
import 'admin_provider.dart';
import 'dashboard.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, authSnapshot) {
        if (authSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // Not logged in
        if (!authSnapshot.hasData) {
          return const AdminLoginSignupScreen();
        }

        final user = authSnapshot.data!;

        // Check if admin exists
        return FutureBuilder<DocumentSnapshot>(
          future:
              FirebaseFirestore.instance
                  .collection('admins')
                  .doc(user.uid)
                  .get(),
          builder: (context, adminSnapshot) {
            if (adminSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (adminSnapshot.hasData && adminSnapshot.data!.exists) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Provider.of<AdminProvider>(context, listen: false).getAdminName();
              });
              return const Dashboard();
            }

            // Logged in but not admin → logout silently
            FirebaseAuth.instance.signOut();
            return const AdminLoginSignupScreen();
          },
        );
      },
    );
  }
}
