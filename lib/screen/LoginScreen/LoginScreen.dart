// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertest/screen/Dashboard/Dashboard.dart';
import 'package:fluttertest/screen/LoginScreen/bloc/login_bloc.dart';
import 'package:fluttertest/utils/Theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoading = false;
  bool canPop = false;
  int exitAppCount = 1;
  final TextEditingController emailText =
      TextEditingController(text: "eve.holt@reqres.in");
  final TextEditingController passwordText =
      TextEditingController(text: "cityslicka");

  void trackTime() {
    Timer(const Duration(seconds: 1), () {
      exitAppCount = 1;
      canPop = true;
      setState(() {});
      print("Time up counter reset");
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (exitAppCount == 1) {
          exitAppCount += 1;
          setState(() {});
          const SnackBar(
            content: Text("Press again to close the app"),
            duration: Duration(seconds: 2),
          );

          trackTime();
          return false;
        } else {
          exitAppCount = 1;
          setState(() {});
          canPop = true;
          setState(() {});
          return true;
        }
      },
      child: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('asset/bg_a.png'),
              opacity: BorderSide.strokeAlignOutside,
              filterQuality: FilterQuality.medium,
              fit: BoxFit.cover,
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: BlocConsumer<LoginBloc, LoginState>(
              listener: (context, state) {
                if (state is LoginFail) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        state.error,
                      ),
                    ),
                  );
                }
                if (state is LoginSuccessState) {
                  isLoading = true;
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Dashboard(),
                      ),
                      (r) => false);
                }
              },
              builder: (context, state) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Row(
                      children: [
                        Text(
                          'Hello User ',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 40,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 32),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: AppColor.primaryColor,
                      ),
                      clipBehavior: Clip.hardEdge,
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              autofocus: true,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor:
                                    AppColor.primaryDark.withOpacity(0.2),
                                contentPadding: const EdgeInsets.all(12),
                                hintText: 'Enter your Email ',
                                hintStyle: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400),
                                isDense: true,
                                counterText: '',
                                border: const OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              style: const TextStyle(color: Colors.black),
                              keyboardType: TextInputType.emailAddress,
                              controller: emailText,
                              textInputAction: TextInputAction.done,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: AppColor.primaryColor,
                      ),
                      clipBehavior: Clip.hardEdge,
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              maxLines: 1,
                              maxLength: 10,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor:
                                    AppColor.primaryDark.withOpacity(0.2),
                                contentPadding: const EdgeInsets.all(12),
                                hintText: 'Enter your Password',
                                hintStyle: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400),
                                isDense: true,
                                counterText: '',
                                border: const OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              style: const TextStyle(color: Colors.black),
                              keyboardType: TextInputType.text,
                              controller: passwordText,
                              textInputAction: TextInputAction.done,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 32),
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          context.read<LoginBloc>().add(LoginRequestedEvent(
                              email: emailText.text.trim(),
                              password: passwordText.text.trim()));
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              const MaterialStatePropertyAll(Colors.white),
                          shape: MaterialStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        child: isLoading
                            ? const SizedBox(
                                height: 25,
                                width: 25,
                                child: CircularProgressIndicator(
                                  color: AppColor.Blue,
                                ),
                              )
                            : const Text(
                                'Submit',
                                style: TextStyle(
                                  color: AppColor.primaryDark,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
