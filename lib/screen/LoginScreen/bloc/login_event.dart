part of 'login_bloc.dart';

@immutable
sealed class LoginEvent {}

class LoginRequestedEvent extends LoginEvent {
  final String email;
  final String password;

  LoginRequestedEvent({required this.email, required this.password});
}

class LoginSuccessEvent extends LoginEvent {}

class LogOut extends LoginEvent {}
