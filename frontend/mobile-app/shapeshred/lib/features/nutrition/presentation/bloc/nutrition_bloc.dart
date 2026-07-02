import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/domain/use_cases/base_use_case.dart';
import '../../domain/entities/nutrition_plan.dart';
import '../../domain/use_cases/get_active_plan_use_case.dart';

part 'nutrition_event.dart';
part 'nutrition_state.dart';

@injectable
class NutritionBloc extends Bloc<NutritionEvent, NutritionState> {
  final GetActivePlanUseCase _getActivePlanUseCase;

  NutritionBloc(this._getActivePlanUseCase) : super(NutritionInitial()) {
    on<LoadActivePlan>((event, emit) async {
      emit(NutritionLoading());
      final result = await _getActivePlanUseCase(NoParams());
      result.fold(
        (failure) => emit(NutritionError(failure.message)),
        (plan) => emit(NutritionLoaded(plan)),
      );
    });
  }
}
