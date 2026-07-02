import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:shapeshred/core/services/auth_service.dart';
import 'package:shapeshred/features/authentication/domain/use_cases/sign_in_use_case.dart';
import 'package:shapeshred/features/authentication/domain/use_cases/sign_up_use_case.dart';

part 'auth_event.dart';
part 'auth_state.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignInUseCase _signInUseCase;
  final SignUpUseCase _signUpUseCase;
  final AuthService _authService;

  AuthBloc(this._signInUseCase, this._signUpUseCase, this._authService)
      : super(AuthInitial()) {
    on<AppStarted>((event, emit) async {
      final isAuthenticated = await _authService.isAuthenticated();
      if (isAuthenticated) {
        emit(AuthAuthenticated());
      } else {
        emit(AuthUnauthenticated());
      }
    });

    on<SignInRequested>((event, emit) async {
      emit(AuthLoading());
      final result = await _signInUseCase(
        SignInParams(email: event.email, password: event.password),
      );
      result.fold(
        (failure) => emit(AuthError(failure.message)),
        (_) => emit(AuthAuthenticated()),
      );
    });

    on<SignUpRequested>((event, emit) async {
      emit(AuthLoading());
      final result = await _signUpUseCase(
        SignUpParams(
          email: event.email,
          password: event.password,
          firstName: event.firstName,
          lastName: event.lastName,
        ),
      );
      result.fold(
        (failure) => emit(AuthError(failure.message)),
        (_) => emit(AuthUnauthenticated()), // Redirect to login after signup
      );
    });

    on<SignOutRequested>((event, emit) async {
      await _authService.logout();
      emit(AuthUnauthenticated());
    });
  }
}
