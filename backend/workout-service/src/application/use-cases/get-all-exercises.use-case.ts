import { Injectable, Inject } from '@nestjs/common';
import { IExerciseRepository } from '../../domain/repositories/exercise.repository.interface';

@Injectable()
export class GetAllExercisesUseCase {
  constructor(
    @Inject('IExerciseRepository')
    private readonly exerciseRepository: IExerciseRepository,
  ) {}

  async execute() {
    return this.exerciseRepository.findAll();
  }
}
