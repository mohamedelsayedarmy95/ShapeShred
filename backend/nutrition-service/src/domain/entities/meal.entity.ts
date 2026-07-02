import { BaseEntity } from '@shapeshred/shared';

export class Meal extends BaseEntity {
  nutritionPlanId: string = '';
  name: string = '';
  mealType: string = '';
  calories: number = 0;
  proteinG: number = 0;
  carbsG: number = 0;
  fatG: number = 0;
  instructions: string[] = [];
  ingredients: Record<string, any> = {};

  constructor(props: Partial<Meal>) {
    super(props.id);
    Object.assign(this, props);
  }
}
