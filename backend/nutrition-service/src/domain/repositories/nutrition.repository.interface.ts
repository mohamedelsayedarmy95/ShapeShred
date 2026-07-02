import { NutritionPlan } from '../entities/nutrition-plan.entity';
import { Meal } from '../entities/meal.entity';

export interface INutritionRepository {
  findActivePlanByUserId(userId: string): Promise<NutritionPlan | null>;
  findMealsByPlanId(planId: string): Promise<Meal[]>;
}
