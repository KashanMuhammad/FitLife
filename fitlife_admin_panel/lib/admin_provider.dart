import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminProvider extends ChangeNotifier {
  String _adminName = "Admin";

  String get adminName => _adminName;

  // Call this once after login
  Future<void> getAdminName() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot doc = await FirebaseFirestore.instance
            .collection('admins')
            .doc(user.uid)
            .get();

        if (doc.exists) {
          _adminName = doc['name'] ?? "Admin";
          notifyListeners();
        }
      }
    } catch (e) {
      print("Error: $e");
    }
  }
}