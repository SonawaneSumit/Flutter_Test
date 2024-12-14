part of 'login_bloc.dart';

@immutable
sealed class LoginState {}

final class LoginInitial extends LoginState {}

class LoginFetchingLoadingState extends LoginState {}

class LoginSuccessState extends LoginState {}

class LoginFail extends LoginState {
  final String error;

  LoginFail(this.error);
}
