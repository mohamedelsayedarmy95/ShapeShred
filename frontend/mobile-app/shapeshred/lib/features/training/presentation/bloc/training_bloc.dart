import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/domain/use_cases/base_use_case.dart';
import '../../domain/entities/exercise.dart';
import '../../domain/use_cases/get_exercises_use_case.dart';

part 'training_event.dart';
part 'training_state.dart';

@injectable
class TrainingBloc extends Bloc<TrainingEvent, TrainingState> {
  final GetExercisesUseCase _getExercisesUseCase;

  TrainingBloc(this._getExercisesUseCase) : super(TrainingInitial()) {
    on<LoadExercises>((event, emit) async {
      emit(TrainingLoading());
      final result = await _getExercisesUseCase(NoParams());
      result.fold(
        (failure) => emit(TrainingError(failure.message)),
        (exercises) => emit(TrainingLoaded(exercises)),
      );
    });
  }
}
