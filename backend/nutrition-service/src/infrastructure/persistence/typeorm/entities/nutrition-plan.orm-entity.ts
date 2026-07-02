import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, UpdateDateColumn } from 'typeorm';

@Entity('nutrition_plans')
export class NutritionPlanOrmEntity {
  @PrimaryGeneratedColumn('uuid')
  id!: string;

  @Column({ name: 'user_id' })
  userId!: string;

  @Column()
  name!: string;

  @Column({ name: 'daily_calories' })
  dailyCalories!: number;

  @Column({ name: 'daily_protein_g' })
  dailyProteinG!: number;

  @Column({ name: 'daily_carbs_g' })
  dailyCarbsG!: number;

  @Column({ name: 'daily_fat_g' })
  dailyFatG!: number;

  @Column({ name: 'is_active', default: false })
  isActive!: boolean;

  @CreateDateColumn({ name: 'created_at' })
  createdAt!: Date;

  @UpdateDateColumn({ name: 'updated_at' })
  updatedAt!: Date;
}
