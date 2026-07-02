import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { INutritionRepository } from '../../../../domain/repositories/nutrition.repository.interface';
import { NutritionPlan } from '../../../../domain/entities/nutrition-plan.entity';
import { Meal } from '../../../../domain/entities/meal.entity';
import { NutritionPlanOrmEntity } from '../entities/nutrition-plan.orm-entity';
import { MealOrmEntity } from '../entities/meal.orm-entity';

@Injectable()
export class TypeOrmNutritionRepository implements INutritionRepository {
  constructor(
    @InjectRepository(NutritionPlanOrmEntity)
    private readonly planRepository: Repository<NutritionPlanOrmEntity>,
    @InjectRepository(MealOrmEntity)
    private readonly mealRepository: Repository<MealOrmEntity>,
  ) {}

  async findActivePlanByUserId(userId: string): Promise<NutritionPlan | null> {
    const ormPlan = await this.planRepository.findOne({ where: { userId, isActive: true } });
    return ormPlan ? this.toPlanDomain(ormPlan) : null;
  }

  async findMealsByPlanId(planId: string): Promise<Meal[]> {
    const ormMeals = await this.mealRepository.find({ where: { nutritionPlanId: planId } });
    return ormMeals.map(this.toMealDomain);
  }

  private toPlanDomain(orm: NutritionPlanOrmEntity): NutritionPlan {
    return new NutritionPlan({
      id: orm.id,
      userId: orm.userId,
      name: orm.name,
      dailyCalories: orm.dailyCalories,
      dailyProteinG: orm.dailyProteinG,
      dailyCarbsG: orm.dailyCarbsG,
      dailyFatG: orm.dailyFatG,
      isActive: orm.isActive,
      createdAt: orm.createdAt,
      updatedAt: orm.updatedAt,
    });
  }

  private toMealDomain(orm: MealOrmEntity): Meal {
    return new Meal({
      id: orm.id,
      nutritionPlanId: orm.nutritionPlanId,
      name: orm.name,
      mealType: orm.mealType,
      calories: orm.calories,
      proteinG: orm.proteinG,
      carbsG: orm.carbsG,
      fatG: orm.fatG,
      instructions: orm.instructions,
      ingredients: orm.ingredients,
      createdAt: orm.createdAt,
    });
  }
}
