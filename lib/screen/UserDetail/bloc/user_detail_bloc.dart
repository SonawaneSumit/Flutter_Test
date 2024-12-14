import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

part 'user_detail_event.dart';
part 'user_detail_state.dart';

class UserDetailBloc extends Bloc<UserDetailEvent, UserDetailState> {
  UserDetailBloc() : super(UserDetailInitial()) {
    on<PickImageEvent>(_onPickImage);
    on<UpdateUserEvent>(_onUpdateUser);
    on<DeleteUserEvent>(_onDeleteUser);
  }

  Future<void> _onPickImage(
      PickImageEvent event, Emitter<UserDetailState> emit) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      emit(ProfileImagePickedState(avatar: pickedFile.path));
    }
  }

  Future<void> _onUpdateUser(
      UpdateUserEvent event, Emitter<UserDetailState> emit) async {
    emit(UserDetailLoading());
    try {
      final response = await http.put(
        Uri.parse('https://reqres.in/api/users/${event.userId}'),
        body: json.encode({
          'name': event.name,
          'job': event.job,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        emit(UserUpdatedSuccessfully());
      } else {
        emit(UserDetailFailure(message: 'Failed to update user'));
      }
    } catch (e) {
      emit(UserDetailFailure(message: e.toString()));
    }
  }

  Future<void> _onDeleteUser(
      DeleteUserEvent event, Emitter<UserDetailState> emit) async {
    emit(UserDetailLoading());
    try {
      final response = await http.delete(
        Uri.parse('https://reqres.in/api/users/${event.userId}'),
      );

      if (response.statusCode == 204) {
        emit(UserDeletedSuccessfully());
      } else {
        emit(UserDetailFailure(message: 'Failed to delete user'));
      }
    } catch (e) {
      emit(UserDetailFailure(message: e.toString()));
    }
  }
}
