part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class LoadProfile extends ProfileEvent {}

class UpdateProfileRequested extends ProfileEvent {
  final UserProfile profile;

  const UpdateProfileRequested(this.profile);

  @override
  List<Object?> get props => [profile];
}
