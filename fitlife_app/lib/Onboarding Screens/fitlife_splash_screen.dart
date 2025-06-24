import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FitlifeSplashScreen extends StatefulWidget {
  const FitlifeSplashScreen({super.key});

  @override
  State<FitlifeSplashScreen> createState() => _FitlifeSplashScreenState();
}

class _FitlifeSplashScreenState extends State<FitlifeSplashScreen> with SingleTickerProviderStateMixin{
  late AnimationController _controller;
  late Animation<double>  _scaleAnimation;
  late Animation<double>  _fadeAnimation;
  @override
  void initState(){
    super.initState();
    _controller= AnimationController(vsync: this,
    duration: const Duration(milliseconds: 1200)
    );
    _scaleAnimation= Tween<double> (begin: 0.3,end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack)
    );
    _fadeAnimation= Tween<double>(begin: 0.3,end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn)
    );
    _controller.forward();
    Future.delayed(Duration(seconds: 5), (){
      Navigator.pushReplacementNamed(context,"" );
    });
  }
  @override
  void dispose(){
    _controller.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: Center(
        child: FadeTransition(opacity: _fadeAnimation,
        child: ScaleTransition(scale: _scaleAnimation,
        child: SvgPicture.asset('assets/images/FitLifelogo.svg'),
        ),
        )
      ),
    );
  }
}
