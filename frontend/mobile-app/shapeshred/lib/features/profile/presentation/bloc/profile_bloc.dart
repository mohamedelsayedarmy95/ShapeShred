import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/domain/use_cases/base_use_case.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/use_cases/get_profile_use_case.dart';
import '../../domain/use_cases/update_profile_use_case.dart';

part 'profile_event.dart';
part 'profile_state.dart';

@injectable
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetProfileUseCase _getProfileUseCase;
  final UpdateProfileUseCase _updateProfileUseCase;

  ProfileBloc(this._getProfileUseCase, this._updateProfileUseCase)
      : super(ProfileInitial()) {
    on<LoadProfile>((event, emit) async {
      emit(ProfileLoading());
      final result = await _getProfileUseCase(NoParams());
      result.fold(
        (failure) => emit(ProfileError(failure.message)),
        (profile) => emit(ProfileLoaded(profile)),
      );
    });

    on<UpdateProfileRequested>((event, emit) async {
      emit(ProfileUpdating());
      final result = await _updateProfileUseCase(event.profile);
      result.fold(
        (failure) => emit(ProfileError(failure.message)),
        (profile) => emit(ProfileLoaded(profile)),
      );
    });
  }
}
