import { BaseEntity } from '@shapeshred/shared';

export class UserProfile extends BaseEntity {
  email: string = '';
  firstName: string = '';
  lastName: string = '';
  dateOfBirth?: Date;
  gender?: string;
  heightCm?: number;
  weightKg?: number;
  fitnessLevel?: string;
  goal?: string;
  isPremium: boolean = false;
  profileImageUrl?: string;
  isActive: boolean = true;

  constructor(props: Partial<UserProfile>) {
    super(props.id);
    Object.assign(this, props);
    if (props.isPremium !== undefined) this.isPremium = props.isPremium;
    if (props.isActive !== undefined) this.isActive = props.isActive;
  }
}
