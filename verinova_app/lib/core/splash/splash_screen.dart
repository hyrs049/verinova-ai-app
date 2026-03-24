import 'dart:async';
import 'package:flutter/material.dart';
import 'package:risea/features/auth/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  static const int splashDuration = 2; // saniye

  @override
  void initState() {
    super.initState();

    // Widget tree tamamen yüklendikten sonra yönlendirme başlat
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Timer(const Duration(seconds: splashDuration), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Image.asset("assets/splash.png", fit: BoxFit.cover),
      ),
    );
  }
}
