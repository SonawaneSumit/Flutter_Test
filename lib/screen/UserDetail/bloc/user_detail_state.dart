part of 'user_detail_bloc.dart';

@immutable
abstract class UserDetailState {}

class UserDetailInitial extends UserDetailState {}

class UserDetailLoading extends UserDetailState {}

class ProfileImagePickedState extends UserDetailState {
  final String avatar;

  ProfileImagePickedState({required this.avatar});
}

class UserUpdatedSuccessfully extends UserDetailState {}

class UserDeletedSuccessfully extends UserDetailState {}

class UserDetailFailure extends UserDetailState {
  final String message;

  UserDetailFailure({required this.message});
}
