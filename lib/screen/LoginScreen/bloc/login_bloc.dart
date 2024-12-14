import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginRequestedEvent>(_onLoginRequested);
  }

  FutureOr<void> _onLoginRequested(
      LoginRequestedEvent event, Emitter<LoginState> emit) async {
    final email = event.email;
    final password = event.password;
    SharedPreferences pref = await SharedPreferences.getInstance();

    bool validateEmail(String email) {
      Pattern pattern =
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regex = RegExp(pattern.toString());
      return (!regex.hasMatch(email)) ? false : true;
    }

    if (email.isEmpty) {
      return emit(LoginFail('Please Enter Email Id'));
    }

    if (!validateEmail(email)) {
      return emit(LoginFail('Enter a valid Email Id'));
    }

    bool result = await InternetConnectionChecker().hasConnection;
    if (result != true) {
      emit(LoginFail("Internet connection not available"));
    }
    emit(LoginFetchingLoadingState());
    try {
      var response = await http.post(Uri.parse("https://reqres.in/api/login"),
          body: {"email": email, "password": password});

      if (response.statusCode == 200) {
        var resBody = jsonDecode(response.body);
        pref.setString("token", resBody["token"]);

        emit(LoginSuccessState());
      } else {
        var resBody = jsonDecode(response.body);
        emit(LoginFail(resBody['error']));
        print("Login Failed");
      }
    } catch (e) {
      print("Login Failed");
    }
  }
}
