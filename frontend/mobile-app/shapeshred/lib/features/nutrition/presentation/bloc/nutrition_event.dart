part of 'nutrition_bloc.dart';

abstract class NutritionEvent extends Equatable {
  const NutritionEvent();

  @override
  List<Object?> get props => [];
}

class LoadActivePlan extends NutritionEvent {}
