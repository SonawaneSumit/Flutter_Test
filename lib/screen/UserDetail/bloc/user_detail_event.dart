part of 'user_detail_bloc.dart';

@immutable
abstract class UserDetailEvent {}

class PickImageEvent extends UserDetailEvent {}

class UpdateUserEvent extends UserDetailEvent {
  final String userId;
  final String name;
  final String job;

  UpdateUserEvent(
      {required this.userId, required this.name, required this.job});
}

class DeleteUserEvent extends UserDetailEvent {
  final String userId;

  DeleteUserEvent({required this.userId});
}
