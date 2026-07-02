import { Injectable, ConflictException, Inject } from '@nestjs/common';
import * as bcrypt from 'bcrypt';
import { IAuthRepository } from '../../domain/repositories/auth.repository.interface';
import { AuthUser } from '../../domain/entities/auth-user.entity';
import { RegisterDto } from '../../presentation/dtos/register.dto';

@Injectable()
export class RegisterUseCase {
  constructor(
    @Inject('IAuthRepository')
    private readonly authRepository: IAuthRepository,
  ) {}

  async execute(dto: RegisterDto): Promise<AuthUser> {
    const existingUser = await this.authRepository.findByEmail(dto.email);
    if (existingUser) {
      throw new ConflictException('User with this email already exists');
    }

    const passwordHash = await bcrypt.hash(dto.password, 10);

    const user = new AuthUser({
      email: dto.email,
      passwordHash,
      firstName: dto.firstName,
      lastName: dto.lastName,
    });

    return this.authRepository.create(user);
  }
}
