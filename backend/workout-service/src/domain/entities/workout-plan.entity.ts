import { BaseEntity } from '@shapeshred/shared';

export class WorkoutPlan extends BaseEntity {
  userId: string = '';
  name: string = '';
  description?: string;
  durationWeeks?: number;
  workoutsPerWeek?: number;
  difficulty?: string;
  goal?: string;
  isActive: boolean = false;
  createdBy: string = '';

  constructor(props: Partial<WorkoutPlan>) {
    super(props.id);
    Object.assign(this, props);
    if (props.isActive !== undefined) this.isActive = props.isActive;
  }
}
