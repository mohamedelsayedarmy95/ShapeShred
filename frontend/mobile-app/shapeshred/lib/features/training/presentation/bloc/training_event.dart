part of 'training_bloc.dart';

abstract class TrainingEvent extends Equatable {
  const TrainingEvent();

  @override
  List<Object?> get props => [];
}

class LoadExercises extends TrainingEvent {}
