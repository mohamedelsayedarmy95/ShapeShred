import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { IExerciseRepository } from '../../../../domain/repositories/exercise.repository.interface';
import { Exercise } from '../../../../domain/entities/exercise.entity';
import { ExerciseOrmEntity } from '../entities/exercise.orm-entity';

@Injectable()
export class TypeOrmExerciseRepository implements IExerciseRepository {
  constructor(
    @InjectRepository(ExerciseOrmEntity)
    private readonly repository: Repository<ExerciseOrmEntity>,
  ) {}

  async findAll(): Promise<Exercise[]> {
    const ormExercises = await this.repository.find();
    return ormExercises.map(this.toDomain);
  }

  async findById(id: string): Promise<Exercise | null> {
    const ormExercise = await this.repository.findOne({ where: { id } });
    return ormExercise ? this.toDomain(ormExercise) : null;
  }

  async findByCategory(category: string): Promise<Exercise[]> {
    const ormExercises = await this.repository.find({ where: { category } });
    return ormExercises.map(this.toDomain);
  }

  private toDomain(orm: ExerciseOrmEntity): Exercise {
    return new Exercise({
      id: orm.id,
      name: orm.name,
      description: orm.description,
      category: orm.category,
      difficulty: orm.difficulty,
      equipmentRequired: orm.equipmentRequired,
      targetMuscles: orm.targetMuscles,
      videoUrl: orm.videoUrl,
      thumbnailUrl: orm.thumbnailUrl,
      instructions: orm.instructions,
      formTips: orm.formTips,
      caloriesPerMinute: Number(orm.caloriesPerMinute),
      isPremium: orm.isPremium,
      createdAt: orm.createdAt,
      updatedAt: orm.updatedAt,
    });
  }
}
