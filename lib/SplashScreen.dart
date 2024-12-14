// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertest/screen/Dashboard/Dashboard.dart';
import 'package:fluttertest/screen/LoginScreen/LoginScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(const Duration(milliseconds: 3000), () async {
      FocusManager.instance.primaryFocus!.unfocus();

      SharedPreferences pref = await SharedPreferences.getInstance();
      String? Token = pref.getString('token');
      if (Token != null) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const Dashboard()),
            (r) => false);
      } else {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
            (r) => false);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        child: Stack(
          children: [
            // Image
            Positioned.fill(
              child: Image.asset(
                "asset/rb_93825.png",
                semanticLabel: "Splash",
                fit: BoxFit.cover,
              ),
            ),
            // Loader positioned below the image
            const Positioned(
              bottom: 100, // Adjust as needed
              left: 0,
              right: 0,
              child: Center(
                child: CircularProgressIndicator(
                  color: Colors.blue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
