import { BaseEntity } from '@shapeshred/shared';

export class AuthUser extends BaseEntity {
  email: string = '';
  passwordHash: string = '';
  firstName: string = '';
  lastName: string = '';
  isActive: boolean = true;

  constructor(props: Partial<AuthUser>) {
    super(props.id);
    Object.assign(this, props);
    if (props.isActive !== undefined) this.isActive = props.isActive;
  }
}
