import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertest/screen/UserDetail/UserDetailScreen.dart';
import 'package:fluttertest/screen/userList/bloc/user_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  bool canPop = false;
  int exitAppCount = 1;
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
        appBar: AppBar(
          title: const Text('User List'),
          backgroundColor: Colors.blueGrey.shade200,
        ),
        body: BlocProvider(
          create: (BuildContext context) =>
              UserBloc()..add(UserlistRequestEvent()),
          child: BlocConsumer<UserBloc, UserState>(
            listener: (context, state) {
              // Optionally
            },
            builder: (context, state) {
              if (state is UserLoadingState) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is UserSuccessState) {
                final users = state.data;
                return ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserDetailsScreen(user: user),
                          ),
                        );
                      },
                      child: Card(
                        elevation: 5,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Colors.blue, Colors.lightBlueAccent],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                                borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  backgroundImage: NetworkImage(user['avatar']),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${user['first_name']} ${user['last_name']}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(user['email']),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              } else if (state is UserFailState) {
                return Center(child: Text(state.error));
              } else {
                return const Center(child: Text('No data available'));
              }
            },
          ),
        ),
      ),
    );
  }
}
