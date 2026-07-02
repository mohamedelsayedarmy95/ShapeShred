import { Exercise } from '../entities/exercise.entity';

export interface IExerciseRepository {
  findAll(): Promise<Exercise[]>;
  findById(id: string): Promise<Exercise | null>;
  findByCategory(category: string): Promise<Exercise[]>;
}
