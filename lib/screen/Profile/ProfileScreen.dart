import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertest/screen/LoginScreen/LoginScreen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final Map<String, dynamic> user = {
    'name': 'John Doe',
    'email': 'johndoe@example.com',
    'avatar': 'https://via.placeholder.com/150',
  };

  bool canPop = false;
  int exitAppCount = 1;
  void trackTime() {
    Timer(const Duration(seconds: 1), () {
      exitAppCount = 1;
      canPop = true;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        if (exitAppCount == 1) {
          exitAppCount = exitAppCount + 1;
          Fluttertoast.showToast(msg: 'Press again to close the app');
          trackTime();
          setState(() {});
          return false;
        } else {
          exitAppCount = 1;
          setState(() {});
          canPop = true;
          setState(() {});
          return true;
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Profile')),
        body: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.lightBlueAccent],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 60,
                backgroundImage:
                    NetworkImage("https://reqres.in/img/faces/7-image.jpg"),
              ),
              const SizedBox(height: 20),
              Text(
                user['name'],
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                user['email'],
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.blue,
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
                onPressed: () async {
                  SharedPreferences pref =
                      await SharedPreferences.getInstance();
                  pref.clear();
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()),
                      (r) => false);
                },
                child: const Text('Logout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
