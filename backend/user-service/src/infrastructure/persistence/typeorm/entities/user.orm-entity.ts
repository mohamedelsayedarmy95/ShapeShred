import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, UpdateDateColumn } from 'typeorm';

@Entity('users')
export class UserOrmEntity {
  @PrimaryGeneratedColumn('uuid')
  id!: string;

  @Column({ unique: true })
  email!: string;

  @Column({ name: 'first_name' })
  firstName!: string;

  @Column({ name: 'last_name' })
  lastName!: string;

  @Column({ name: 'date_of_birth', type: 'date', nullable: true })
  dateOfBirth!: Date;

  @Column({ nullable: true })
  gender!: string;

  @Column({ name: 'height_cm', type: 'decimal', precision: 5, scale: 2, nullable: true })
  heightCm!: number;

  @Column({ name: 'weight_kg', type: 'decimal', precision: 5, scale: 2, nullable: true })
  weightKg!: number;

  @Column({ name: 'fitness_level', nullable: true })
  fitnessLevel!: string;

  @Column({ nullable: true })
  goal!: string;

  @Column({ name: 'is_premium', default: false })
  isPremium!: boolean;

  @Column({ name: 'profile_image_url', nullable: true })
  profileImageUrl!: string;

  @Column({ name: 'is_active', default: true })
  isActive!: boolean;

  @CreateDateColumn({ name: 'created_at' })
  createdAt!: Date;

  @UpdateDateColumn({ name: 'updated_at' })
  updatedAt!: Date;
}
