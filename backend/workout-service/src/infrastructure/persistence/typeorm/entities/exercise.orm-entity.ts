import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, UpdateDateColumn } from 'typeorm';

@Entity('exercises')
export class ExerciseOrmEntity {
  @PrimaryGeneratedColumn('uuid')
  id!: string;

  @Column()
  name!: string;

  @Column({ type: 'text', nullable: true })
  description!: string;

  @Column()
  category!: string;

  @Column()
  difficulty!: string;

  @Column({ name: 'equipment_required' })
  equipmentRequired!: string;

  @Column('text', { array: true, name: 'target_muscles' })
  targetMuscles!: string[];

  @Column({ name: 'video_url', nullable: true })
  videoUrl!: string;

  @Column({ name: 'thumbnail_url', nullable: true })
  thumbnailUrl!: string;

  @Column('text', { array: true })
  instructions!: string[];

  @Column('text', { array: true, name: 'form_tips' })
  formTips!: string[];

  @Column({ name: 'calories_per_minute', type: 'decimal', precision: 5, scale: 2, nullable: true })
  caloriesPerMinute!: number;

  @Column({ name: 'is_premium', default: false })
  isPremium!: boolean;

  @CreateDateColumn({ name: 'created_at' })
  createdAt!: Date;

  @UpdateDateColumn({ name: 'updated_at' })
  updatedAt!: Date;
}
