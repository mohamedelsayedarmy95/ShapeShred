import { Controller, Post, Body } from '@nestjs/common';
import { RegisterUseCase } from '../../application/use-cases/register.use-case';
import { LoginUseCase } from '../../application/use-cases/login.use-case';
import { RegisterDto } from '../dtos/register.dto';
import { LoginDto } from '../dtos/login.dto';

@Controller('auth')
export class AuthController {
  constructor(
    private readonly registerUseCase: RegisterUseCase,
    private readonly loginUseCase: LoginUseCase,
  ) {}

  @Post('register')
  async register(@Body() dto: RegisterDto) {
    const user = await this.registerUseCase.execute(dto);
    return {
      id: user.id,
      email: user.email,
      firstName: user.firstName,
      lastName: user.lastName,
    };
  }

  @Post('login')
  async login(@Body() dto: LoginDto) {
    return this.loginUseCase.execute(dto);
  }
}
