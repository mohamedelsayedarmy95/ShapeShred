import { BaseEntity } from '@shapeshred/shared';

export class Exercise extends BaseEntity {
  name: string = '';
  description?: string;
  category: string = '';
  difficulty: string = '';
  equipmentRequired: string = '';
  targetMuscles: string[] = [];
  videoUrl?: string;
  thumbnailUrl?: string;
  instructions: string[] = [];
  formTips: string[] = [];
  caloriesPerMinute?: number;
  isPremium: boolean = false;

  constructor(props: Partial<Exercise>) {
    super(props.id);
    Object.assign(this, props);
    if (props.isPremium !== undefined) this.isPremium = props.isPremium;
  }
}
