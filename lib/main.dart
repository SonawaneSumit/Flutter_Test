import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertest/SplashScreen.dart';
import 'package:fluttertest/screen/LoginScreen/bloc/login_bloc.dart';
import 'package:fluttertest/utils/Theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) {
        return LoginBloc();
      },
      child: MaterialApp(
        title: 'Flutter Test',
        theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: AppColor.primaryDark),
            useMaterial3: true,
            scaffoldBackgroundColor: Colors.white),
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
      ),
    );
  }
}
