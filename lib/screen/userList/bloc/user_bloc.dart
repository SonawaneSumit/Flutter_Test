// ignore_for_file: non_constant_identifier_names

import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserInitial()) {
    on<UserlistRequestEvent>(_UserlistRequestEvent);
  }

  FutureOr<void> _UserlistRequestEvent(
      UserlistRequestEvent event, Emitter<UserState> emit) async {
    try {
      emit(UserLoadingState());
      final response =
          await http.get(Uri.parse('https://reqres.in/api/users?page=1'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        emit(UserSuccessState(data: data['data']));
      } else {
        emit(UserFailState('Failed to load users'));
      }
    } catch (e) {
      emit(UserFailState('Failed to load users'));
    }
  }
}
