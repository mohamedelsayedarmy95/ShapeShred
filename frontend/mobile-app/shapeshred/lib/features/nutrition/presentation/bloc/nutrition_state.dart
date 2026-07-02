part of 'nutrition_bloc.dart';

abstract class NutritionState extends Equatable {
  const NutritionState();

  @override
  List<Object?> get props => [];
}

class NutritionInitial extends NutritionState {}

class NutritionLoading extends NutritionState {}

class NutritionLoaded extends NutritionState {
  final NutritionPlan plan;

  const NutritionLoaded(this.plan);

  @override
  List<Object?> get props => [plan];
}

class NutritionError extends NutritionState {
  final String message;

  const NutritionError(this.message);

  @override
  List<Object?> get props => [message];
}
