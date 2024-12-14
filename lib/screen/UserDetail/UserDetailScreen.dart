import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertest/screen/UserDetail/bloc/user_detail_bloc.dart';

class UserDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> user;

  UserDetailsScreen({required this.user});

  @override
  _UserDetailsScreenState createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  late String avatar;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController jobController = TextEditingController();

  @override
  void initState() {
    super.initState();
    avatar = widget.user['avatar'];
    nameController.text = widget.user['first_name'];
    jobController.text = "Developer"; // Example default value
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserDetailBloc(),
      child: Scaffold(
        appBar: AppBar(
            title: Text(
                '${widget.user['first_name']} ${widget.user['last_name']}')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocConsumer<UserDetailBloc, UserDetailState>(
            listener: (context, state) {
              if (state is UserUpdatedSuccessfully) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('User updated successfully')),
                );
                Navigator.pop(context);
              } else if (state is UserDeletedSuccessfully) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('User deleted')),
                );
                Navigator.pop(context); // Navigate back to the previous screen
              } else if (state is UserDetailFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              }
            },
            builder: (context, state) {
              if (state is ProfileImagePickedState) {
                avatar = state.avatar;
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: avatar.startsWith('http')
                          ? NetworkImage(avatar)
                          : FileImage(File(avatar)) as ImageProvider,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<UserDetailBloc>().add(PickImageEvent());
                      },
                      child: const Text('Change Profile Image'),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: jobController,
                    decoration: const InputDecoration(labelText: 'Job'),
                  ),
                  const SizedBox(height: 20),
                  if (state is UserDetailLoading)
                    const Center(child: CircularProgressIndicator())
                  else
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          context.read<UserDetailBloc>().add(UpdateUserEvent(
                                userId: widget.user['id'].toString(),
                                name: nameController.text,
                                job: jobController.text,
                              ));
                        },
                        child: const Text(
                          'Update User',
                          style: TextStyle(color: Colors.green),
                        ),
                      ),
                    ),
                  const SizedBox(height: 20),
                  if (state is UserDetailLoading)
                    const Center(child: CircularProgressIndicator())
                  else
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          context.read<UserDetailBloc>().add(DeleteUserEvent(
                              userId: widget.user['id'].toString()));
                        },
                        child: const Text(
                          'Delete User',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
