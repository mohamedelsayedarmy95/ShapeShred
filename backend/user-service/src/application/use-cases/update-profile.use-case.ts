import { Injectable, NotFoundException, Inject } from '@nestjs/common';
import { IUserProfileRepository } from '../../domain/repositories/user-profile.repository.interface';
import { UpdateProfileDto } from '../../presentation/dtos/update-profile.dto';

@Injectable()
export class UpdateProfileUseCase {
  constructor(
    @Inject('IUserProfileRepository')
    private readonly userRepository: IUserProfileRepository,
  ) {}

  async execute(userId: string, dto: UpdateProfileDto) {
    const user = await this.userRepository.findById(userId);
    if (!user) {
      throw new NotFoundException('User not found');
    }

    if (dto.firstName) user.firstName = dto.firstName;
    if (dto.lastName) user.lastName = dto.lastName;
    if (dto.dateOfBirth) user.dateOfBirth = new Date(dto.dateOfBirth);
    if (dto.gender) user.gender = dto.gender;
    if (dto.heightCm) user.heightCm = dto.heightCm;
    if (dto.weightKg) user.weightKg = dto.weightKg;
    if (dto.fitnessLevel) user.fitnessLevel = dto.fitnessLevel;
    if (dto.goal) user.goal = dto.goal;

    return this.userRepository.update(user);
  }
}
