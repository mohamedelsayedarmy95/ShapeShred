import { Injectable, Inject, NotFoundException } from '@nestjs/common';
import { INutritionRepository } from '../../domain/repositories/nutrition.repository.interface';

@Injectable()
export class GetActiveNutritionPlanUseCase {
  constructor(
    @Inject('INutritionRepository')
    private readonly nutritionRepository: INutritionRepository,
  ) {}

  async execute(userId: string) {
    const plan = await this.nutritionRepository.findActivePlanByUserId(userId);
    if (!plan) {
      throw new NotFoundException('No active nutrition plan found');
    }

    const meals = await this.nutritionRepository.findMealsByPlanId(plan.id);

    return {
      ...plan,
      meals,
    };
  }
}
