import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, ManyToOne, JoinColumn } from 'typeorm';
import { UserOrmEntity } from './user.orm-entity';

@Entity('refresh_tokens')
export class RefreshTokenOrmEntity {
  @PrimaryGeneratedColumn('uuid')
  id!: string;

  @Column()
  token!: string;

  @Column({ name: 'user_id' })
  userId!: string;

  @ManyToOne(() => UserOrmEntity)
  @JoinColumn({ name: 'user_id' })
  user!: UserOrmEntity;

  @Column({ name: 'expires_at' })
  expiresAt!: Date;

  @Column({ name: 'is_revoked', default: false })
  isRevoked!: boolean;

  @CreateDateColumn({ name: 'created_at' })
  createdAt!: Date;
}
