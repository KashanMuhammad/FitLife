import 'package:firebase_core/firebase_core.dart';
import 'package:fitlife_app/sign_up.dart';
import 'package:flutter/material.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: 'AIzaSyDf8Snq2D6Ln9i_kSimkjtwBrDuPAqJzDs',
      appId: '1:1001660030744:android:5730f8428bdedabcfc486d',
      messagingSenderId: '1001660030744',
      projectId: 'fitlife-app-bd9b4',
      storageBucket: 'fitlife-app-bd9b4.firebasestorage.app',
    ),
  );
  runApp(
    const MaterialApp(home: SignUp(), debugShowCheckedModeBanner: false),
  );
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: Text(
          "FitLife App",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 150),
        ),
      ),
    );
  }
}
