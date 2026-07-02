import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn } from 'typeorm';

@Entity('meals')
export class MealOrmEntity {
  @PrimaryGeneratedColumn('uuid')
  id!: string;

  @Column({ name: 'nutrition_plan_id' })
  nutritionPlanId!: string;

  @Column()
  name!: string;

  @Column({ name: 'meal_type' })
  mealType!: string;

  @Column()
  calories!: number;

  @Column({ name: 'protein_g' })
  proteinG!: number;

  @Column({ name: 'carbs_g' })
  carbsG!: number;

  @Column({ name: 'fat_g' })
  fatG!: number;

  @Column('text', { array: true })
  instructions!: string[];

  @Column('jsonb')
  ingredients!: Record<string, any>;

  @CreateDateColumn({ name: 'created_at' })
  createdAt!: Date;
}
