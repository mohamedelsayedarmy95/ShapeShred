import { Controller, Get, Req } from '@nestjs/common';
import { GetActiveNutritionPlanUseCase } from '../../application/use-cases/get-active-nutrition-plan.use-case';

@Controller('nutrition')
export class NutritionController {
  constructor(private readonly getActivePlanUseCase: GetActiveNutritionPlanUseCase) {}

  @Get('active-plan')
  async getActivePlan(@Req() req: any) {
    const userId = req.user?.userId || 'test-user-id';
    return this.getActivePlanUseCase.execute(userId);
  }
}
