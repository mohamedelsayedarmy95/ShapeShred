import { BaseEntity } from '@shapeshred/shared';

export class NutritionPlan extends BaseEntity {
  userId: string = '';
  name: string = '';
  dailyCalories: number = 0;
  dailyProteinG: number = 0;
  dailyCarbsG: number = 0;
  dailyFatG: number = 0;
  isActive: boolean = false;

  constructor(props: Partial<NutritionPlan>) {
    super(props.id);
    Object.assign(this, props);
    if (props.isActive !== undefined) this.isActive = props.isActive;
  }
}
