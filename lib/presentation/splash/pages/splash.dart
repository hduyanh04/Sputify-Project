import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sputify/core/config/assets/app_vectors.dart';
import 'package:sputify/presentation/intro/pages/get_started.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sputify/presentation/home/pages/home.dart';
import 'package:sputify/presentation/auth/pages/signin.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    redirect();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: SvgPicture.asset(AppVectors.logo)),
    );
  }

  Future<void> redirect() async {
    await Future.delayed(const Duration(seconds: 2));

    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // User is already logged in → go to HomePage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else {
      // User not logged in → go to GetStartedPage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const GetStartedPage()),
      );
    }
  }
}