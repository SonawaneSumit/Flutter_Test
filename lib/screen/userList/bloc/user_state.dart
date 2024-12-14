// ignore_for_file: must_be_immutable

part of 'user_bloc.dart';

@immutable
sealed class UserState {}

final class UserInitial extends UserState {}

final class UserLoadingState extends UserState {}

final class UserSuccessState extends UserState {
  var data;
  UserSuccessState({required this.data});
}

final class UserFailState extends UserState {
  final String error;

  UserFailState(this.error);
}
