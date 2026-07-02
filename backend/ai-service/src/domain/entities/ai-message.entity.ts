import { BaseEntity } from '@shapeshred/shared';

export enum MessageRole {
  USER = 'user',
  COACH = 'assistant',
  SYSTEM = 'system',
}

export class AiMessage extends BaseEntity {
  userId!: string;
  role!: MessageRole;
  content!: string;
  metadata?: Record<string, any>;

  constructor(props: Partial<AiMessage>) {
    super(props.id);
    Object.assign(this, props);
  }
}
