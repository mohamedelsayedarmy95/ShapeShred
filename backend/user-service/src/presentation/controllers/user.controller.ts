import { Controller, Get, Put, Body, Req } from '@nestjs/common';
import { GetProfileUseCase } from '../../application/use-cases/get-profile.use-case';
import { UpdateProfileUseCase } from '../../application/use-cases/update-profile.use-case';
import { UpdateProfileDto } from '../dtos/update-profile.dto';

@Controller('users')
export class UserController {
  constructor(
    private readonly getProfileUseCase: GetProfileUseCase,
    private readonly updateProfileUseCase: UpdateProfileUseCase,
  ) {}

  @Get('profile')
  async getProfile(@Req() req: any) {
    // In a real app, userId comes from the JWT payload attached by the AuthGuard
    const userId = req.user?.userId || 'test-user-id';
    return this.getProfileUseCase.execute(userId);
  }

  @Put('profile')
  async updateProfile(@Req() req: any, @Body() dto: UpdateProfileDto) {
    const userId = req.user?.userId || 'test-user-id';
    return this.updateProfileUseCase.execute(userId, dto);
  }
}
