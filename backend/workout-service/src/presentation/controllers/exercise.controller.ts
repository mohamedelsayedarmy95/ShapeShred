import { Controller, Get } from '@nestjs/common';
import { GetAllExercisesUseCase } from '../../application/use-cases/get-all-exercises.use-case';

@Controller('exercises')
export class ExerciseController {
  constructor(private readonly getAllExercisesUseCase: GetAllExercisesUseCase) {}

  @Get()
  async getAll() {
    return this.getAllExercisesUseCase.execute();
  }
}
