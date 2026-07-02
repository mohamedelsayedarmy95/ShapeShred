// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:connectivity_plus/connectivity_plus.dart' as _i895;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shapeshred/core/di/register_module.dart' as _i578;
import 'package:shapeshred/core/network/dio_client.dart' as _i672;
import 'package:shapeshred/core/network/interceptors/auth_interceptor.dart'
    as _i183;
import 'package:shapeshred/core/network/network_info.dart' as _i328;
import 'package:shapeshred/core/services/auth_service.dart' as _i104;
import 'package:shapeshred/core/storage/secure_storage.dart' as _i1032;
import 'package:shapeshred/features/ai/data/repositories/ai_repository_impl.dart'
    as _i6;
import 'package:shapeshred/features/ai/domain/repositories/ai_repository.dart'
    as _i861;
import 'package:shapeshred/features/ai/domain/use_cases/send_message_use_case.dart'
    as _i590;
import 'package:shapeshred/features/ai/presentation/bloc/ai_chat_bloc.dart'
    as _i669;
import 'package:shapeshred/features/authentication/data/repositories/auth_repository_impl.dart'
    as _i486;
import 'package:shapeshred/features/authentication/domain/repositories/auth_repository.dart'
    as _i703;
import 'package:shapeshred/features/authentication/domain/use_cases/sign_in_use_case.dart'
    as _i126;
import 'package:shapeshred/features/authentication/domain/use_cases/sign_up_use_case.dart'
    as _i318;
import 'package:shapeshred/features/authentication/presentation/bloc/auth_bloc.dart'
    as _i100;
import 'package:shapeshred/features/nutrition/data/repositories/nutrition_repository_impl.dart'
    as _i825;
import 'package:shapeshred/features/nutrition/domain/repositories/nutrition_repository.dart'
    as _i532;
import 'package:shapeshred/features/nutrition/domain/use_cases/get_active_plan_use_case.dart'
    as _i718;
import 'package:shapeshred/features/nutrition/presentation/bloc/nutrition_bloc.dart'
    as _i902;
import 'package:shapeshred/features/profile/data/repositories/profile_repository_impl.dart'
    as _i323;
import 'package:shapeshred/features/profile/domain/repositories/profile_repository.dart'
    as _i841;
import 'package:shapeshred/features/profile/domain/use_cases/get_profile_use_case.dart'
    as _i717;
import 'package:shapeshred/features/profile/domain/use_cases/update_profile_use_case.dart'
    as _i505;
import 'package:shapeshred/features/profile/presentation/bloc/profile_bloc.dart'
    as _i534;
import 'package:shapeshred/features/training/data/repositories/training_repository_impl.dart'
    as _i375;
import 'package:shapeshred/features/training/domain/repositories/training_repository.dart'
    as _i765;
import 'package:shapeshred/features/training/domain/use_cases/get_exercises_use_case.dart'
    as _i628;
import 'package:shapeshred/features/training/presentation/bloc/training_bloc.dart'
    as _i744;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final registerModule = _$RegisterModule();
    gh.factory<_i1032.SecureStorage>(() => _i1032.SecureStorage());
    gh.lazySingleton<_i895.Connectivity>(() => registerModule.connectivity);
    gh.lazySingleton<_i328.NetworkInfo>(
        () => _i328.NetworkInfoImpl(gh<_i895.Connectivity>()));
    gh.lazySingleton<_i104.AuthService>(
        () => _i104.AuthService(gh<_i1032.SecureStorage>()));
    gh.factory<_i183.AuthInterceptor>(
        () => _i183.AuthInterceptor(gh<_i104.AuthService>()));
    gh.lazySingleton<_i672.DioClient>(
        () => _i672.DioClient(gh<_i183.AuthInterceptor>()));
    gh.factory<_i703.AuthRepository>(() => _i486.AuthRepositoryImpl(
          gh<_i672.DioClient>(),
          gh<_i104.AuthService>(),
        ));
    gh.factory<_i126.SignInUseCase>(
        () => _i126.SignInUseCase(gh<_i703.AuthRepository>()));
    gh.factory<_i318.SignUpUseCase>(
        () => _i318.SignUpUseCase(gh<_i703.AuthRepository>()));
    gh.factory<_i765.TrainingRepository>(
        () => _i375.TrainingRepositoryImpl(gh<_i672.DioClient>()));
    gh.factory<_i532.NutritionRepository>(
        () => _i825.NutritionRepositoryImpl(gh<_i672.DioClient>()));
    gh.factory<_i841.ProfileRepository>(
        () => _i323.ProfileRepositoryImpl(gh<_i672.DioClient>()));
    gh.factory<_i861.AiRepository>(
        () => _i6.AiRepositoryImpl(gh<_i672.DioClient>()));
    gh.factory<_i590.SendMessageUseCase>(
        () => _i590.SendMessageUseCase(gh<_i861.AiRepository>()));
    gh.factory<_i718.GetActivePlanUseCase>(
        () => _i718.GetActivePlanUseCase(gh<_i532.NutritionRepository>()));
    gh.factory<_i100.AuthBloc>(() => _i100.AuthBloc(
          gh<_i126.SignInUseCase>(),
          gh<_i318.SignUpUseCase>(),
          gh<_i104.AuthService>(),
        ));
    gh.factory<_i902.NutritionBloc>(
        () => _i902.NutritionBloc(gh<_i718.GetActivePlanUseCase>()));
    gh.factory<_i628.GetExercisesUseCase>(
        () => _i628.GetExercisesUseCase(gh<_i765.TrainingRepository>()));
    gh.factory<_i669.AiChatBloc>(
        () => _i669.AiChatBloc(gh<_i590.SendMessageUseCase>()));
    gh.factory<_i717.GetProfileUseCase>(
        () => _i717.GetProfileUseCase(gh<_i841.ProfileRepository>()));
    gh.factory<_i505.UpdateProfileUseCase>(
        () => _i505.UpdateProfileUseCase(gh<_i841.ProfileRepository>()));
    gh.factory<_i744.TrainingBloc>(
        () => _i744.TrainingBloc(gh<_i628.GetExercisesUseCase>()));
    gh.factory<_i534.ProfileBloc>(() => _i534.ProfileBloc(
          gh<_i717.GetProfileUseCase>(),
          gh<_i505.UpdateProfileUseCase>(),
        ));
    return this;
  }
}

class _$RegisterModule extends _i578.RegisterModule {}
