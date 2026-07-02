part of 'training_bloc.dart';

abstract class TrainingState extends Equatable {
  const TrainingState();

  @override
  List<Object?> get props => [];
}

class TrainingInitial extends TrainingState {}

class TrainingLoading extends TrainingState {}

class TrainingLoaded extends TrainingState {
  final List<Exercise> exercises;

  const TrainingLoaded(this.exercises);

  @override
  List<Object?> get props => [exercises];
}

class TrainingError extends TrainingState {
  final String message;

  const TrainingError(this.message);

  @override
  List<Object?> get props => [message];
}
